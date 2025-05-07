package airpsx.service.filesystem;
import hx.well.http.Request;
class FileSystemStreamService extends AbstractHttpFileStreamService {
    public function filePath(request:Request):String {
        return request.route("path");
    }

    public function bufferSize():Int {
        return 1024 * 10;
    }

    public function contentType(request:Request):String {
        var extension = request.path.substring(request.path.lastIndexOf("."));
        switch (extension) {
            case ".mp4":
                return "video/mp4";
            case ".webm":
                return "video/webm";
            default:
                return '${extension} undefined';
        }
    }

    public function isDownloadRequest(request:Request):Bool {
        return false;
    }

    public function basePath():Null<String> {
        return null;
    }
}