package ;
import airpsx.hscript.HScriptData;
import airpsx.command.SetupPublicCommand;
import airpsx.command.SetupDatabaseCommand;
import airpsx.command.InitializeCommand;
import sys.thread.Thread;
import sys.FileSystem;
import hx.well.boot.BaseBoot;
import hx.well.route.Route;
import hx.well.server.AbstractServer;
import airpsx.Config;
import hx.well.facades.Config as HxWellConfig;
import airpsx.server.Server;
import hx.well.database.Connection;
import airpsx.type.DatabaseType;
import hx.well.facades.Schedule;
import hx.well.console.BatchCommandExecutor;
import hx.well.console.CommandExecutor;
import hx.well.facades.Validator;
import airpsx.command.TaskExecuteCommand;
import airpsx.command.TemperatureLogCommand;
import airpsx.command.TimestampUpdateCommand;
import cpp.lib.LibKernel;
import airpsx.command.ServePackageCommand;
import airpsx.command.KillServePackageCommand;
import sys.ssl.Socket;
import airpsx.route.ApiRoute;
using hx.well.tools.RouteElementTools;

class Boot extends BaseBoot {
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
            var h = new haxe.Http('http://127.0.0.1:${Config.HTTP_PORT}/api/server/kill');
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

        Connection.create(DatabaseType.DEFAULT, {path: Config.DB_PATH});
        Connection.create(DatabaseType.TASK, {path: Config.TASK_DB_PATH});
        Connection.create(DatabaseType.APP, {path: Config.SYSTEM_APP_DB_PATH});
        Connection.create(DatabaseType.APP_INFO, {path: Config.SYSTEM_APP_INFO_DB_PATH});
        Connection.create(DatabaseType.SCRIPT_DB, {path: Config.SCRIPT_DB_PATH});

        // api group
        Route.path("/api")
            .group(ApiRoute);

        // Always use framework instead of 404 page.
        Route.status(404)
            .file('${Config.DATA_PATH}/public/index.html', 200);

        LibKernel.sendNotificationRequest('AirPSX listening at ${Config.HTTP_PORT}');

        Schedule.get().fixedRate("timestamp:update", 60000);
    }

    public function servers():Array<AbstractServer> {
        return [
            new Server()
        ];
    }
}
