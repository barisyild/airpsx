package protocols.http.services.filesystem;

import sys.FileSystem;
import sys.io.File;
import sys.net.Socket;
import haxe.Int64;
import sys.io.FileOutput;
import haxe.Exception;
import protocols.http.HTTPRequest;
using StringTools;
using tools.OutputTools;

class FileSystemUploadService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var path = request.path.replace("/api/fs/upload/", "");
        if(FileSystem.exists(path))
            return {success: false, message: "file exists"};

        var contentLength:Int64 = Int64.parseString(request.headers.get("Content-Length"));

        try {
            var output:FileOutput = File.write(path + ".temp", true);
            output.writeInputSize(socket.input, contentLength);
        } catch (e:Exception)
        {
            return {success: false, message: e.toString()};
        }

        FileSystem.rename(path + ".temp", path);

        return {success: true};
    }
}
