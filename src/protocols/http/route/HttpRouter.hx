package protocols.http.route;
import haxe.http.HttpMethod;
import protocols.http.services.filesystem.FileSystemDownloadService;
import protocols.http.services.ProcessListService;
import protocols.http.services.profile.ProfileListService;
import protocols.http.services.system.SystemInfoService;
import protocols.http.services.system.SystemStatusService;
import protocols.http.services.UploadService;
import protocols.http.services.AbstractHttpService;
import protocols.http.services.PublicService;
import protocols.http.services.filesystem.FileSystemListService;
import protocols.http.route.HttpRouterElement;
import protocols.http.services.HScriptService;
import protocols.http.services.CPUStatisticsService;
import protocols.http.services.TitleImageService;
import protocols.http.services.KillServerService;
import protocols.http.services.BlankService;
import protocols.http.services.filesystem.StorageInfoService;
import protocols.http.services.application.ApplicationListService;
import protocols.http.services.application.ApplicationRunService;
import protocols.http.services.profile.ProfileImageService;
import protocols.http.services.save.SaveBackupService;
import protocols.http.services.task.TaskListService;
import protocols.http.services.task.TaskCreateService;
import protocols.http.services.task.TaskDetailService;
import protocols.http.services.task.TaskUpdateService;
import protocols.http.services.Api404Service;
import protocols.http.services.task.TaskDeleteService;
import protocols.http.services.task.TaskLogService;
import protocols.http.services.task.TaskStatusService;
import protocols.http.services.filesystem.FileSystemUploadService;
import protocols.http.HTTPRequest;

class HttpRouter {
    private static var routes:Array<HttpRouterElement> = [];

    public static function init() {
        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/upload")
            .setHandler(new UploadService())
            .setStream(true);

        createRouteElement()
            .setMethod(HttpMethod.Post)
            .setPath("/api/fs/list")
            .setHandler(new FileSystemListService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/fs/download/*")
            .setHandler(new FileSystemDownloadService());

        createRouteElement()
            .setMethod(HttpMethod.Post)
            .setPath("/api/fs/upload/*")
            .setHandler(new FileSystemUploadService())
            .setStream(true);

        #if orbis
        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/system/status")
            .setHandler(new SystemStatusService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/system/info")
            .setHandler(new SystemInfoService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/profile/list")
            .setHandler(new ProfileListService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/profile/image/*")
            .setHandler(new ProfileImageService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/system/stats")
            .setHandler(new CPUStatisticsService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/title/image/*")
            .setHandler(new TitleImageService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/storage/info")
            .setHandler(new StorageInfoService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/process/list")
            .setHandler(new ProcessListService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/app/list")
            .setHandler(new ApplicationListService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/app/run/*")
            .setHandler(new ApplicationRunService());


        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/save/backup/*")
            .setHandler(new SaveBackupService());
        #end

        // Task
        createRouteElement()
            .setMethod(HttpMethod.Post)
            .setPath("/api/task/create")
            .setHandler(new TaskCreateService());

        createRouteElement()
            .setMethod(HttpMethod.Post)
            .setPath("/api/task/delete")
            .setHandler(new TaskDeleteService());

        createRouteElement()
            .setMethod(HttpMethod.Post)
            .setPath("/api/task/detail")
            .setHandler(new TaskDetailService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/task/list")
            .setHandler(new TaskListService());

        createRouteElement()
            .setMethod(HttpMethod.Post)
            .setPath("/api/task/update")
            .setHandler(new TaskUpdateService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/task/status")
            .setHandler(new TaskStatusService());

        createRouteElement()
            .setMethod(HttpMethod.Post)
            .setPath("/api/task/log")
            .setHandler(new TaskLogService());

        createRouteElement()
            .setMethod(HttpMethod.Post)
            .setPath("/api/server/kill")
            .setHandler(new KillServerService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/blank")
            .setHandler(new BlankService());

        createRouteElement()
            .setMethod(HttpMethod.Post)
            .setPath("/api/hscript")
            .setHandler(new HScriptService());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/api/*")
            .setHandler(new Api404Service());

        createRouteElement()
            .setMethod(HttpMethod.Get)
            .setPath("/*")
            .setHandler(new PublicService())
            .setStream(true);

        log();
    }

    private static function log():Void
    {
        trace('HTTP Router initialized.');
        for(route in routes)
        {
            trace('${route.getMethod()} - ${route.getPath()} service registered.');
        }
    }

    public static function createRouteElement():HttpRouterElement {
        var httpRouterElement = new HttpRouterElement();
        routes.push(httpRouterElement);
        return httpRouterElement;
    }

    public static function resolveRequest(httpRequest:HTTPRequest):HttpRouterElement {
        for (route in routes) {
            var pattern = new EReg(route.getPath(), "i");
            if (route.getMethod() == httpRequest.method && pattern.match(httpRequest.path)) {
                return route;
            }
        }
        return null;
    }
}