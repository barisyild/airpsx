package hx.well.route;
import hx.well.route.RouteGroup;
import hx.well.route.Route;
import hx.well.handler.UploadHandler;
import hx.well.http.ResponseStatic;
import hx.well.handler.pkg.UploadPackageHandler;
import hx.well.handler.pkg.ReceivePackageHandler;
import hx.well.handler.pkg.InstallPackageHandler;
import hx.well.handler.filesystem.FileSystemListHandler;
import hx.well.handler.filesystem.FileSystemExecutePayloadHandler;
import hx.well.handler.filesystem.FileSystemDownloadHandler;
import hx.well.handler.filesystem.FileSystemUploadHandler;
import hx.well.handler.filesystem.FileSystemStreamHandler;
import hx.well.handler.system.SystemStatusHandler;
import hx.well.handler.system.SystemInfoHandler;
import hx.well.handler.CPUStatisticsHandler;
import hx.well.handler.profile.ProfileListHandler;
import hx.well.handler.profile.ProfileImageHandler;
import hx.well.handler.TitleImageHandler;
import hx.well.handler.filesystem.StorageInfoHandler;
import hx.well.handler.ProcessListHandler;
import hx.well.handler.media.MediaListHandler;
import hx.well.handler.media.MediaThumbnailHandler;
import hx.well.handler.media.MediaStreamHandler;
import hx.well.handler.application.ApplicationListHandler;
import hx.well.handler.application.ApplicationRunHandler;
import hx.well.handler.save.SaveBackupHandler;
import hx.well.handler.task.TaskCreateHandler;
import hx.well.handler.task.TaskDeleteHandler;
import hx.well.handler.task.TaskDetailHandler;
import hx.well.handler.task.TaskListHandler;
import hx.well.handler.task.TaskUpdateHandler;
import hx.well.handler.task.TaskStatusHandler;
import hx.well.handler.task.TaskLogHandler;
import hx.well.handler.KillServerHandler;
import hx.well.handler.BlankHandler;
import hx.well.handler.script.remote.RemoteScriptListHandler;
import hx.well.handler.script.remote.RemoteScriptImageHandler;
import hx.well.handler.script.remote.RemoteScriptExecuteHandler;
import hx.well.handler.script.remote.RemoteScriptHeartbeatHandler;
import hx.well.handler.script.ScriptExecutorHandler;
import hx.well.http.ResponseBuilder;
using hx.well.tools.RouteElementTools;

class ApiRoute extends RouteGroup {
    public function template():Void {
        Route.get("/upload")
            .handler(new UploadHandler())
            .setStream(true);

        Route.path("/package").group(() -> {
            Route.get("/{file}.crc")
                .handle((a) -> {
                    trace("error");
                    return ResponseBuilder.asString("", 404);
                }).where("file", "[A-Z]{2}[0-9]{4}-[A-Z]{4}[0-9]{5}_[0-9]{2}-[A-Z0-9]{16}");

            Route.post("/upload")
                .handler(new UploadPackageHandler())
                .setStream(true);

            // Console only API, do not call from web!
            Route.get("/{sessionKey}.pkg")
                .handler(new ReceivePackageHandler())
                .where("sessionKey", "[\\-_0-9a-zA-Z]{32}");

            Route.post("/install")
                .handler(new InstallPackageHandler());
        });

        Route.path("/fs").group(() -> {
            Route.post("/list")
                .handler(new FileSystemListHandler());

            Route.post("/payload")
                .handler(new FileSystemExecutePayloadHandler());

            Route.get("/download/{encodedPath}")
                .handler(new FileSystemDownloadHandler())
                .where("encodedPath", "(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$"); //Validate Base64 Regex

            Route.post("/upload/{path}")
                .handler(new FileSystemUploadHandler())
                .setStream(true)
                .where("path", ".*");

            Route.get("/stream/{path}")
                .handler(new FileSystemStreamHandler())
                .where("path", ".*");
        });

        #if orbis
        Route.path("/system").group(() -> {
            Route.get("/status")
                .handler(new SystemStatusHandler());

            Route.get("/info")
                .handler(new SystemInfoHandler());

            Route.get("/stats")
                .handler(new CPUStatisticsHandler());
        });

        Route.path("/profile").group(() -> {
            Route.get("/list")
                .handler(new ProfileListHandler());

            // TODO: Add regex to profileId
            Route.get("/image/{profileId}")
                .handler(new ProfileImageHandler())
                .where("profileId", "[0-9a-f]{8}");
        });

        Route.path("/title").group(() -> {
            Route.get("/image/{titleId}")
                .handler(new TitleImageHandler())
                .where("titleId", "[A-Z]{4}[0-9]{5}");
        });

        Route.get("/storage/info")
            .handler(new StorageInfoHandler());

        Route.get("/process/list")
            .handler(new ProcessListHandler());

        Route.path("/media").group(() -> {
            Route.get("/list")
                .handler(new MediaListHandler());

            Route.get("/thumbnails/{path}")
                .handler(new MediaThumbnailHandler())
                .where("path", ".*");

            Route.get("/{path}")
                .handler(new MediaStreamHandler())
                .where("path", ".*");
        });

        Route.path("/app").group(() -> {
            Route.get("/list")
                .handler(new ApplicationListHandler());

            Route.get("/run/{titleId}")
                .handler(new ApplicationRunHandler())
                .where("titleId", "[A-Z]{4}[0-9]{5}");
        });

        Route.get("/save/backup/{profileId?}")
            .handler(new SaveBackupHandler())
            .where("profileId", "[0-9a-f]{8}");
        #end

        Route.path("/task").group(() -> {
            Route.post("/create")
                .handler(new TaskCreateHandler());

            Route.post("/delete")
                .handler(new TaskDeleteHandler());

            Route.post("/detail")
                .handler(new TaskDetailHandler());

            Route.get("/list")
                .handler(new TaskListHandler());

            Route.post("/update")
                .handler(new TaskUpdateHandler());

            Route.get("/status")
                .handler(new TaskStatusHandler());

            Route.post("/log")
                .handler(new TaskLogHandler());
        });

        Route.post("/server/kill")
            .handler(new KillServerHandler());

        Route.get("/blank")
            .handler(new BlankHandler());

        Route.path("/script").group(() -> {
            Route.path("/remote").group(() -> {
                Route.get("/list")
                    .handler(new RemoteScriptListHandler());

                Route.get("/image/{key}")
                    .handler(new RemoteScriptImageHandler());

                Route.post("/execute")
                    .handler(new RemoteScriptExecuteHandler());

                Route.post("/heartbeat")
                    .handler(new RemoteScriptHeartbeatHandler());
            });

            Route.post("execute")
                .handler(new ScriptExecutorHandler());
        });
    }
}
