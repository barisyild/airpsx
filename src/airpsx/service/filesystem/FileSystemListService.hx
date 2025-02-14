package airpsx.service.filesystem;
import sys.net.Socket;
import sys.FileSystem;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;

using StringTools;

// WIP
class FileSystemListService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        /*var jsonData = parseJson(request, [
            "path" => String
        ]);*/

        var jsonData = haxe.Json.parse(request.bodyBytes.toString());

        var path = jsonData.path;
        if(path == "")
            path = "/";

        if(FileSystem.exists(path) == false) {
            return {
                error: "Path not found",
            };
        }

        var files = sys.FileSystem.readDirectory(path);
        if(files == null) {
            return [];
        }
        return files.map(function(file) {
            var stat = sys.FileSystem.stat(path + file);

            return {
                name: file,
                isDirectory: sys.FileSystem.isDirectory(path + file),
                gid: stat.gid,
                uid: stat.uid,
                atime: stat.atime,
                mtime: stat.mtime,
                ctime: stat.ctime,
                size: stat.size,
                dev: stat.dev,
                ino: stat.ino,
                nlink: stat.nlink,
                rdev: stat.rdev,
                mode: stat.mode,
            };
        });
    }
}
