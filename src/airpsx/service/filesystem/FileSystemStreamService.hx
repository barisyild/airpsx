package airpsx.service.filesystem;
import hx.well.http.Request;
import airpsx.utils.FileExtensionUtils;
class FileSystemStreamService extends AbstractHttpFileStreamService {
    public function filePath(request:Request):String {
        return request.route("path");
    }

    public function bufferSize():Int {
        return 1024 * 10;
    }

    public function contentType(request:Request):String {
        var extension = request.path.substring(request.path.lastIndexOf(".") + 1);
        return FileExtensionUtils.resolveContentType(extension);
    }

    public function isDownloadRequest(request:Request):Bool {
        return false;
    }

    public function basePath():Null<String> {
        return null;
    }
}