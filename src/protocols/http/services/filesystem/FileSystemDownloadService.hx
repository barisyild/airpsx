package protocols.http.services.filesystem;
import sys.net.Socket;
import sys.FileSystem;
import sys.io.FileInput;
import haxe.tar.StreamTarFile;
import sys.FileStat;
import sys.io.File;
import haxe.tar.TarEntry;
import haxe.Int64;
import haxe.tar.TarCompress;
import utils.FileUtils;
import protocols.http.services.filesystem.AbstractHttpFileStreamService;
import utils.StringUtils;
import haxe.crypto.Base64;
import protocols.http.HTTPRequest;
using StringTools;

// WIP
class FileSystemDownloadService extends AbstractHttpFileStreamService {
    public function filePath(request:HTTPRequest):String {
        var pathRaw = Base64.decode(request.path.replace("/api/fs/download/", "")).toString();
        var paths:Array<String> = pathRaw.split(",");
        return paths[0];
    }

    public override function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var pathRaw = Base64.decode(request.path.replace("/api/fs/download/", "")).toString();
        var paths:Array<String> = pathRaw.split(",");
        if(paths.length == 0)
            return "File Not Found";

        if(paths.length > 100)
            return "Maximum 100 path supported at same time";

        trace(haxe.Json.stringify(paths));

        var isArchive:Bool = paths.length > 1 || FileSystem.isDirectory(paths[0]);
        if(isArchive)
        {
            var isAllFilesAvailable:Bool = true;
            for(path in paths)
            {
                isAllFilesAvailable = FileSystem.exists(path);
                if(!isAllFilesAvailable)
                    return '${path} file is not available';
            }

            var path:String = StringUtils.findCommonPrefix(paths);
            path = path.endsWith("/") ? path.substring(0, path.length - 1) : path;

            var fileName:String = path.substring(path.lastIndexOf("/") + 1);
            if(fileName == "")
                fileName = "root";

            var files:Array<String> = FileUtils.getRecursiveFiles(...paths);
            var tarFileSize:Int64 = TarCompress.getTarFileSize(files, path);

            socket.output.writeString("HTTP/1.1 200 OK\n");
            socket.output.writeString('Content-Length: ${tarFileSize}\n');
            socket.output.writeString('Content-Disposition: attachment; filename=\"${fileName}.tar\"\n');
            socket.output.writeString("\n");


            var i:Int = 0;
            var streamTarFile:StreamTarFile = new StreamTarFile();
            streamTarFile.write(socket.output, () -> {
                var file = files.shift();
                if(file == null)
                    return null;

                var input:FileInput = null;
                var length:Int64 = 0;

                var isDirectory:Bool = file.endsWith("/");
                if(!isDirectory)
                {
                    input = File.read(file, true);
                    var stats:FileStat = FileSystem.stat(file);
                    length = stats.size;
                }

                var entry = new TarEntry();
                entry.name = file.substr(path.length + 1);
                entry.length = length;
                entry.input = input;
                entry.isDirectory = isDirectory;

                i++;

                return entry;
            });

            return null;
        }

        return super.execute(request, socket);
    }

    public function bufferSize():Int {
        return 1024 * 10;
    }

    public function contentType(request:HTTPRequest):String {
        return "application/octet-stream";
    }

    public function isDownloadRequest(request:HTTPRequest):Bool
    {
        return true;
    }

    public function basePath():Null<String> {
        return null;
    }
}
