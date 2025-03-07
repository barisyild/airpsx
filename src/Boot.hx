package ;
import airpsx.hscript.HScriptData;
import airpsx.command.SetupPublicCommand;
import airpsx.command.SetupDatabaseCommand;
import airpsx.command.InitializeCommand;
import sys.thread.Thread;
import airpsx.service.UploadService;
import airpsx.service.filesystem.FileSystemListService;
import airpsx.service.filesystem.FileSystemDownloadService;
import airpsx.service.filesystem.FileSystemUploadService;
import airpsx.service.filesystem.FileSystemExecutePayloadService;
import airpsx.service.system.SystemStatusService;
import airpsx.service.system.SystemInfoService;
import airpsx.service.CPUStatisticsService;
import airpsx.service.profile.ProfileListService;
import airpsx.service.profile.ProfileImageService;
import airpsx.service.TitleImageService;
import airpsx.service.filesystem.StorageInfoService;
import airpsx.service.ProcessListService;
import airpsx.service.application.ApplicationListService;
import airpsx.service.application.ApplicationRunService;
import airpsx.service.save.SaveBackupService;
import airpsx.service.task.TaskCreateService;
import airpsx.service.task.TaskDeleteService;
import airpsx.service.task.TaskDetailService;
import airpsx.service.task.TaskListService;
import airpsx.service.task.TaskUpdateService;
import airpsx.service.task.TaskStatusService;
import airpsx.service.task.TaskLogService;
import airpsx.service.KillServerService;
import airpsx.service.BlankService;
import airpsx.service.HScriptService;
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
using hx.well.tools.RouteElementTools;

class Boot extends BaseBoot {
    public function boot():Void {
        #if (!release)
        Thread.create(() -> {
            Sys.sleep(1000);

            AirPSX.exit(0);
        });
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

        initializeRoute();

        Schedule.get().fixedRate("timestamp:update", 60000);
    }

    private function initializeRoute():Void
    {
        // api group
        Route.path("/api").group(() -> {
            Route.get("/upload")
                .handler(new UploadService())
                .setStream(true);

            Route.path("/fs").group(() -> {
                Route.post("/list")
                    .handler(new FileSystemListService());

                Route.post("/payload")
                    .handler(new FileSystemExecutePayloadService());

                Route.get("/download/{encodedPath}")
                    .handler(new FileSystemDownloadService())
                    .where("encodedPath", "(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$"); //Validate Base64 Regex

                Route.post("/upload/{path}")
                    .handler(new FileSystemUploadService())
                    .setStream(true)
                    .where("path", ".*");
            });

            #if orbis
            Route.path("/system").group(() -> {
                Route.get("/status")
                    .handler(new SystemStatusService());

                Route.get("/info")
                    .handler(new SystemInfoService());

                Route.get("/stats")
                    .handler(new CPUStatisticsService());
            });

            Route.path("/profile").group(() -> {
                Route.get("/list")
                    .handler(new ProfileListService());

                // TODO: Add regex to profileId
                Route.get("/image/{profileId}")
                    .handler(new ProfileImageService())
                    .where("profileId", "[0-9a-f]{8}");
            });

            Route.path("/title").group(() -> {
                Route.get("/image/{titleId}")
                    .handler(new TitleImageService())
                    .where("titleId", "[A-Z]{4}[0-9]{5}");
            });

            Route.get("/storage/info")
                .handler(new StorageInfoService());

            Route.get("/process/list")
                .handler(new ProcessListService());

            Route.path("/app").group(() -> {
                Route.get("/list")
                    .handler(new ApplicationListService());

                Route.get("/run/{titleId}")
                    .handler(new ApplicationRunService())
                    .where("titleId", "[A-Z]{4}[0-9]{5}");
            });

            Route.get("/save/backup/{profileId?}")
                .handler(new SaveBackupService())
                .where("profileId", "[0-9a-f]{8}");
            #end

            Route.path("/task").group(() -> {
                Route.post("/create")
                    .handler(new TaskCreateService());

                Route.post("/delete")
                    .handler(new TaskDeleteService());

                Route.post("/detail")
                    .handler(new TaskDetailService());

                Route.get("/list")
                    .handler(new TaskListService());

                Route.post("/update")
                    .handler(new TaskUpdateService());

                Route.get("/status")
                    .handler(new TaskStatusService());

                Route.post("/log")
                    .handler(new TaskLogService());
            });

            Route.post("/server/kill")
                .handler(new KillServerService());

            Route.get("/blank")
                .handler(new BlankService());

            Route.post("/hscript")
                .handler(new HScriptService());
        });

        // Always use framework instead of 404 page.
        Route.status(404)
            .file('${Config.DATA_PATH}/public/index.html', 200);

        LibKernel.sendNotificationRequest('AirPSX listening at ${Config.HTTP_PORT}');
    }

    public function servers():Array<AbstractServer> {
        return [
            new Server()
        ];
    }
}
