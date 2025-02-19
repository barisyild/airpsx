package airpsx.service.filesystem;

import sys.FileSystem;
import sys.io.File;
import haxe.Int64;
import sys.io.FileOutput;
import haxe.Exception;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;
using airpsx.tools.OutputTools;
import hx.well.http.RequestStatic.socket;

class FileSystemUploadService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var path = request.input("path");
        if(FileSystem.exists(path))
            return {success: false, message: "file exists"};

        var contentLength:Int64 = Int64.parseString(request.header("Content-Length"));

        try {
            var output:FileOutput = File.write(path + ".temp", true);
            output.writeInputSize(socket().input, contentLength);
        } catch (e:Exception)
        {
            return {success: false, message: e.toString()};
        }

        FileSystem.rename(path + ".temp", path);

        return {success: true};
    }
}
