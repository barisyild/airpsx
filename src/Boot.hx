package ;
import hscript.HScriptData;
import command.CommandExecutor;
import command.SetupPublicCommand;
import command.SetupDatabaseCommand;
import command.InitializeCommand;
import sys.thread.Thread;
import airpsx.service.UploadService;
import airpsx.service.filesystem.FileSystemListService;
import airpsx.service.filesystem.FileSystemDownloadService;
import airpsx.service.filesystem.FileSystemUploadService;
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
import type.DatabaseType;
using hx.well.tools.RouteElementTools;

class Boot extends BaseBoot {
    public function boot():Void {
        #if (!release)
        Thread.create(() -> {
            Sys.sleep(1000);

            AirPSX.exit(0);
        });
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
        var commandExecutor = new CommandExecutor();
        commandExecutor.addComamnd(new SetupPublicCommand());
        commandExecutor.addComamnd(new SetupDatabaseCommand());
        commandExecutor.addComamnd(new InitializeCommand());
        // TODO: implement schedulers in hxwell
        //commandExecutor.addComamnd(new SchedulerCommand());
        commandExecutor.execute();

        Connection.create(DatabaseType.DEFAULT, {path: Config.DB_PATH});
        Connection.create(DatabaseType.TASK, {path: Config.TASK_DB_PATH});
        Connection.create(DatabaseType.APP, {path: Config.SYSTEM_APP_DB_PATH});

        initializeRoute();
    }

    private function initializeRoute():Void
    {
        // api group
        Route.group("/api", () -> {
            Route.get("/upload")
                .handler(new UploadService())
                .setStream(true);

            Route.group("/fs", () -> {
                Route.post("/list")
                    .handler(new FileSystemListService());

                Route.get("/download/*")
                    .handler(new FileSystemDownloadService());

                Route.post("/upload/*")
                    .handler(new FileSystemUploadService())
                    .setStream(true);
            });

            #if orbis
            Route.group("/system", () -> {
                Route.get("/status")
                    .handler(new SystemStatusService());

                Route.get("/info")
                    .handler(new SystemInfoService());

                Route.get("/stats")
                    .handler(new CPUStatisticsService());
            });

            Route.group("/profile", () -> {
                Route.get("/list")
                    .handler(new ProfileListService());

                Route.get("/image/*")
                    .handler(new ProfileImageService());
            });

            Route.group("/title", () -> {
                Route.get("/image/*")
                    .handler(new TitleImageService());
            });

            Route.get("/storage/info")
                .handler(new StorageInfoService());

            Route.get("/process/list")
                .handler(new ProcessListService());

            Route.group("/app", () -> {
                Route.get("/list")
                    .handler(new ApplicationListService());

                Route.get("/run/*")
                    .handler(new ApplicationRunService());
            });

            Route.get("/save/backup/*")
                .handler(new SaveBackupService());
            #end

            Route.group("/task", () -> {
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
    }

    public function servers():Array<AbstractServer> {
        return [
            new Server()
        ];
    }
}
