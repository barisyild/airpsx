package airpsx.service.filesystem;
import sys.net.Socket;
import sys.FileSystem;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.http.RequestStatic.request;
import hx.well.validator.ValidatorRule;
using StringTools;

// WIP
class FileSystemListService extends AbstractService {
    public function validator():Bool {
        return request().validate([
            "path" => [ValidatorRule.Required, ValidatorRule.String]
        ]);
    }

    public function execute(request:Request):AbstractResponse {
        var path = request.input("path");
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
