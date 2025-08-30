package hx.well.provider;

import hx.well.route.Route;
import airpsx.command.TemperatureLogCommand;
import airpsx.command.SetupPublicCommand;
import hx.well.console.CommandExecutor;
import airpsx.command.ServePackageCommand;
import hx.well.facades.Validator;
import sys.FileSystem;
import airpsx.command.InitializeCommand;
import airpsx.command.TimestampUpdateCommand;
import hx.well.console.BatchCommandExecutor;
import hx.well.database.Connection;
import cpp.lib.LibKernel;
import airpsx.type.DatabaseType;
import airpsx.command.SetupDatabaseCommand;
import airpsx.Const;
import sys.ssl.Socket;
import sys.thread.Thread;
import hx.well.route.ApiRoute;
import airpsx.command.TaskExecuteCommand;
import hx.well.facades.Schedule;
import airpsx.command.KillServePackageCommand;
import airpsx.hscript.HScriptData;
using hx.well.tools.RouteElementTools;
import hx.well.facades.Config as HxWellConfig;

class BootProvider extends AbstractProvider {
    public function boot():Void {
        #if (!release)
        Thread.create(() -> {
            Sys.sleep(1000);

            AirPSX.exit(0);
        });
        #end

        #if orbis
        Socket.DEFAULT_VERIFY_CERT = false;
        #end

        Validator.extend("fileExists", (attribute:String, value:Dynamic, params:Array<Dynamic>) -> {
            if(!(value is String))
                return false;

            return FileSystem.exists(value) && !FileSystem.isDirectory(value);
        });

        // register commands
        CommandExecutor.register(TaskExecuteCommand);
        CommandExecutor.register(TemperatureLogCommand);
        CommandExecutor.register(TimestampUpdateCommand);
        CommandExecutor.register(ServePackageCommand);
        CommandExecutor.register(KillServePackageCommand);

        #if orbis
        Schedule.get().fixedRate("package:serve", 100);
        Schedule.get().fixedRate("package:kill-serve", 1000);
        #end

        // set config
        HxWellConfig.set("cache.path", '${Config.DATA_PATH}/cache');
        HxWellConfig.set("session.path", '${Config.DATA_PATH}/session');
        HxWellConfig.set("public.path", '${Config.DATA_PATH}/public');

        HScriptData.init();

        // Kill old process
        try
        {
            var h = new haxe.Http('http://127.0.0.1:${Const.HTTP_PORT}/api/server/kill');
            var r = null;
            h.onData = function(d) {
                r = d;
            }
            h.onError = function(e) {
                trace("onError");
                throw e;
            }
            trace("request start");
            h.cnxTimeout = 1;
            h.request(true);
            trace("request end");
            if(r == "OK")
            {
                trace("The old process was found and killed.");
                Sys.sleep(1);
            }
        }
        catch (e)
        {

        }

        Const.init();

        #if cpp
        trace("Current PID: " + cpp.NativeSys.sys_get_pid());
        #end

        // Initialize Server
        var commandExecutor = new BatchCommandExecutor();
        commandExecutor.addCommand(SetupPublicCommand);
        commandExecutor.addCommand(SetupDatabaseCommand);
        commandExecutor.addCommand(InitializeCommand);
        // TODO: implement schedulers in hxwell
        //commandExecutor.addCommand(new SchedulerCommand());
        commandExecutor.execute();

        Connection.create(DatabaseType.DEFAULT, {path: Const.DB_PATH});
        Connection.create(DatabaseType.TASK, {path: Const.TASK_DB_PATH});
        Connection.create(DatabaseType.APP, {path: Const.SYSTEM_APP_DB_PATH});
        Connection.create(DatabaseType.APP_INFO, {path: Const.SYSTEM_APP_INFO_DB_PATH});
        Connection.create(DatabaseType.SCRIPT_DB, {path: Const.SCRIPT_DB_PATH});

        // api group
        Route.path("/api")
            .group(ApiRoute);

        // Always use framework instead of 404 page.
        Route.status(404)
            .file('${Const.DATA_PATH}/public/index.html', 200);

        LibKernel.sendNotificationRequest('AirPSX listening at ${Const.HTTP_PORT}');

        Schedule.get().fixedRate("timestamp:update", 60000);
    }
}
