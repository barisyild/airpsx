package airpsx.service.media;
import airpsx.service.filesystem.AbstractHttpFileStreamService;
import hx.well.http.Request;
import hx.well.http.ResponseStatic.abort;

class MediaThumbnailService extends AbstractHttpFileStreamService {
    public function new() {
        super();
    }

    public function filePath(request:Request):String {
        var previewExtensions = ["jxr", "png", "jpg", "jpeg"];

        for (ext in previewExtensions) {
            var path = '/user/av_contents/thumbnails/${request.route("path")}.${ext}';
            if (sys.FileSystem.exists(path)) {
                return path;
            }
        }

        abort(404); // Not Found
        return null;
    }

    public function basePath():Null<String> {
        return "/user/av_contents/thumbnails/";
    }

    public function bufferSize():Int {
        return 1024 * 10;
    }

    public function contentType(request:Request):Null<String> {
        var path = filePath(request);
        var ext = path.substring(path.lastIndexOf('.') + 1);

        switch (ext) {
            case "jxr":
                return "image/vnd.ms-photo";
            case "png":
                return "image/png";
            case "jpg" | "jpeg":
                return "image/jpeg";
            default:
                return 'undefined ${ext}';
        }
    }

    public function isDownloadRequest(request:Request):Bool {
        return false;
    }
}