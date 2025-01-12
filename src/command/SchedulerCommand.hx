package command;

import lib.LibKernel;
import sys.db.Sqlite;
import utils.NTPUtils;
import lib.sys.LibSysTime;
import hx.concurrent.executor.Executor.TaskFuture;
import lib.Process;
import sys.io.File;
import sys.FileSystem;
import utils.RuleScriptUtils;
import utils.TypeUtils;
import haxe.io.Output;
import haxe.io.NullOutput;
import cpp.vm.Mutex;
import type.TaskStatus;
using tools.ExecutorTools;

class SchedulerCommand extends Command {
    public static var taskMutex:Mutex = new Mutex();
    //public static var taskData:Null<{id:Int, startAt:Float}> = null;

    public function new() {
        super();
    }

    public function execute():Void {
        var updateTimestampFuture:TaskFuture<Bool> = null;

        updateTimestampFuture = AirPSX.executor.submitWithGC(() -> {
            var ntpSeconds = NTPUtils.readTime().seconds;
            var systemSeconds = Sys.time();

            var diff = ntpSeconds - systemSeconds;
            if(diff > 60 || diff < -60) {
                LibKernel.sendNotificationRequest('System time was synchronized via the NTP server because it was out of date.');
                #if orbis
                LibSysTime.setTime(ntpSeconds);
                #end
            }

            updateTimestampFuture.cancel();
            executeBeforeSystemClockSynchronized();

            return true;
        }, FIXED_RATE(60000));
    }

    private function executeBeforeSystemClockSynchronized():Void
    {
        #if orbis
        AirPSX.executor.submitWithGC(() -> {
            var socSensorTemperature:Int = LibKernel.getSocSensorTemperature();
            var temperature:Int = LibKernel.cpuTemperature;
            var frequency = LibKernel.cpuFrequency;

            var runningApp = Process.getRunningApp();
            var titleID = runningApp != null ? runningApp.titleID : "";

            trace('socSensorTemperature: ${socSensorTemperature}');
            trace('temperature: ${temperature}');
            trace('frequency: ${frequency}');
            trace('titleID: ${titleID}');


            var db = Sqlite.open(Config.DB_PATH);
            db.request('INSERT INTO stats (socSensorTemperature, temperature, frequency, titleID) VALUES (${socSensorTemperature}, ${temperature}, ${frequency}, "${titleID}");');
            db.close();

            return true;
        }, FIXED_RATE(60000));
        #end

        AirPSX.executor.submitWithGC(() -> {
            if(!taskMutex.tryAcquire())
            {
                trace("Task already running.");
                return;
            }
            try {
                trace("execute");
                var db = Sqlite.open(Config.TASK_DB_PATH);
                var resultSet = db.request('SELECT id, script, frequency, logs, lastRun FROM tasks WHERE enabled = 1 and script <> ""');
                var results = resultSet.results();
                while (results.length > 0)
                {
                    var result:Dynamic = results.first();
                    results.remove(result);
                    var frequency:Int = result.frequency;
                    var lastRunDate:Date = Date.fromString(result.lastRun ?? Date.fromTime(0).toString());
                    if(lastRunDate.getTime() + ((frequency - 30) * 1000) < Date.now().getTime())
                    {
                        var id:Int = result.id;
                        trace('execute task ${id}');

                        //taskData = {id: id, startAt: Date.now().getTime() / 1000};

                        // Update task state to running
                        db.request('UPDATE tasks SET status = ${TaskStatus.RUNNING} WHERE id = ${id}');

                        var script:String = result.script;

                        var filePath:String = '${Config.DATA_PATH}/task/';
                        if(!FileSystem.exists(filePath))
                            FileSystem.createDirectory(filePath);


                        var logs:Bool = TypeUtils.parseBool(result.logs);
                        var result:Dynamic = null;
                        var output:Output;
                        if(logs)
                        {
                            output = File.append('${filePath}/${id}.log');
                        }else{
                            output = new NullOutput();
                        }

                        var executionMilliseconds:Float = haxe.Timer.stamp();
                        output.writeString('[${Date.now()}] execute start\n');
                        try {
                            result = RuleScriptUtils.execute(script, output);
                        } catch (e) {

                        }
                        var isSuccess:Bool = TypeUtils.parseBool(result);
                        var increaseKey:String = isSuccess ? "success" : "failed";

                        // Update task state to idle
                        db.request('UPDATE tasks SET status = ${TaskStatus.IDLE}, lastRun = datetime(\'now\',\'localtime\'), ${increaseKey} = ${increaseKey} + 1 WHERE id = ${id}');

                        output.writeString('[${Date.now()}] execution ${increaseKey}, took ${haxe.Timer.stamp() - executionMilliseconds}ms\n');
                    }
                }

                db.close();
            } catch (e) {
                //taskData = null;
                taskMutex.release();
                throw e;
            }
            //taskData = null;
            taskMutex.release();
        }, FIXED_RATE(60000, 60000));
    }
}