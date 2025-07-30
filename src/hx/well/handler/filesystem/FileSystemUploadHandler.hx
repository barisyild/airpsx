package hx.well.handler.filesystem;

import sys.FileSystem;
import sys.io.File;
import haxe.Int64;
import sys.io.FileOutput;
import haxe.Exception;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;
using airpsx.tools.OutputTools;

class FileSystemUploadHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var path = request.input("path");
        if(FileSystem.exists(path))
            return {success: false, message: "file exists"};

        var contentLength:Int64 = Int64.parseString(request.header("Content-Length"));

        try {
            var output:FileOutput = File.write(path + ".temp", true);
            output.writeInputSize(request.context.input, contentLength);
        } catch (e:Exception)
        {
            return {success: false, message: e.toString()};
        }

        FileSystem.rename(path + ".temp", path);

        return {success: true};
    }
}
