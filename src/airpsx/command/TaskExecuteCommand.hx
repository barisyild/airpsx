package airpsx.command;
import hx.well.console.AbstractCommand;
import sys.thread.Mutex;
import haxe.io.NullOutput;
import sys.io.File;
import utils.RuleScriptUtils;
import utils.TypeUtils;
import sys.FileSystem;
import type.TaskStatus;
import hx.well.facades.DBStatic;
import haxe.io.Output;
import type.DatabaseType;
class TaskExecuteCommand extends AbstractCommand {
    public static var taskMutex:Mutex = new Mutex();

    public override function group():String {
        return "task";
    }

    public function signature():String {
        return "execute";
    }

    public function description():String {
        return "execute scheduled tasks";
    }

    public function handle<T>():T {
        if(!taskMutex.tryAcquire())
        {
            trace("Task already running.");
            return cast false;
        }
        try {
            trace("execute");
            var db = DBStatic.connection(DatabaseType.TASK);
            var resultSet = db.query('SELECT id, script, frequency, logs, lastRun FROM tasks WHERE enabled = 1 and script <> ""');
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
                    db.query('UPDATE tasks SET status = ? WHERE id = ?', TaskStatus.RUNNING, id);

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
                    db.query('UPDATE tasks SET status = ?, lastRun = datetime(\'now\',\'localtime\'), ? = ? + 1 WHERE id = ?', TaskStatus.IDLE, increaseKey, increaseKey, id);

                    output.writeString('[${Date.now()}] execution ${increaseKey}, took ${haxe.Timer.stamp() - executionMilliseconds}ms\n');
                }
            }
        } catch (e) {
            taskMutex.release();
            throw e;
        }
        taskMutex.release();

        return cast true;
    }
}
