package protocols.http.services.filesystem;
import sys.net.Socket;
import sys.FileSystem;
import haxe.io.Path;
import protocols.http.HTTPRequest;

using StringTools;

// WIP
class FileSystemListService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var jsonData = parseJson(request, [
            "path" => String
        ]);

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
