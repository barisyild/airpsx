package airpsx.route;
import hx.well.route.RouteGroup;
import hx.well.route.Route;
import airpsx.service.UploadService;
import hx.well.http.ResponseStatic;
import airpsx.service.pkg.UploadPackageService;
import airpsx.service.pkg.ReceivePackageService;
import airpsx.service.pkg.InstallPackageService;
import airpsx.service.filesystem.FileSystemListService;
import airpsx.service.filesystem.FileSystemExecutePayloadService;
import airpsx.service.filesystem.FileSystemDownloadService;
import airpsx.service.filesystem.FileSystemUploadService;
import airpsx.service.filesystem.FileSystemStreamService;
import airpsx.service.system.SystemStatusService;
import airpsx.service.system.SystemInfoService;
import airpsx.service.CPUStatisticsService;
import airpsx.service.profile.ProfileListService;
import airpsx.service.profile.ProfileImageService;
import airpsx.service.TitleImageService;
import airpsx.service.filesystem.StorageInfoService;
import airpsx.service.ProcessListService;
import airpsx.service.media.MediaListService;
import airpsx.service.media.MediaThumbnailService;
import airpsx.service.media.MediaStreamService;
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
import airpsx.service.script.remote.RemoteScriptListService;
import airpsx.service.script.remote.RemoteScriptImageService;
import airpsx.service.script.remote.RemoteScriptExecuteService;
import airpsx.service.script.remote.RemoteScriptHeartbeatService;
import airpsx.service.script.ScriptExecutorService;
using hx.well.tools.RouteElementTools;

class ApiRoute extends RouteGroup {
    public function template():Void {
        Route.get("/upload")
            .handler(new UploadService())
            .setStream(true);

        Route.path("/package").group(() -> {
            Route.get("/{file}.crc")
                .handle((a) -> {
                    trace("error");
                    return ResponseStatic.response().asString("", 404);
                }).where("file", "[A-Z]{2}[0-9]{4}-[A-Z]{4}[0-9]{5}_[0-9]{2}-[A-Z0-9]{16}");

            Route.post("/upload")
                .handler(new UploadPackageService())
                .setStream(true);

            // Console only API, do not call from web!
            Route.get("/{sessionKey}.pkg")
                .handler(new ReceivePackageService())
                .where("sessionKey", "[\\-_0-9a-zA-Z]{32}");

            Route.post("/install")
                .handler(new InstallPackageService());
        });

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

            Route.get("/stream/{path}")
                .handler(new FileSystemStreamService())
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

        Route.path("/media").group(() -> {
            Route.get("/list")
                .handler(new MediaListService());

            Route.get("/thumbnails/{path}")
                .handler(new MediaThumbnailService())
                .where("path", ".*");

            Route.get("/{path}")
                .handler(new MediaStreamService())
                .where("path", ".*");
        });

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

        Route.path("/script").group(() -> {
            Route.path("/remote").group(() -> {
                Route.get("/list")
                    .handler(new RemoteScriptListService());

                Route.get("/image/{key}")
                    .handler(new RemoteScriptImageService());

                Route.post("/execute")
                    .handler(new RemoteScriptExecuteService());

                Route.post("/heartbeat")
                    .handler(new RemoteScriptHeartbeatService());
            });

            Route.post("execute")
                .handler(new ScriptExecutorService());
        });
    }
}
