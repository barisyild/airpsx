package hx.well.handler.filesystem;

import hx.well.handler.AbstractHandler;
import hx.well.http.AbstractResponse;
import hx.well.http.Request;
import airpsx.Const;
import uuid.Uuid;
import sys.io.File;
import sys.io.FileOutput;
using StringTools;
using airpsx.tools.OutputTools;

class FileSystemTempFileHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var tempFilePath:String = '${Const.TEMP_PATH}/${Uuid.v4()}';
        var fileOutput:FileOutput = File.write(tempFilePath, true);
        var bytesLeft:Int = Std.parseInt(request.header("Content-Length"));

        while (bytesLeft > 0) {
            var bufsize:Int = Std.int(Math.min(bytesLeft, 1024));
            fileOutput.write(request.context.input.read(bufsize));

            bytesLeft -= bufsize;
        }
        fileOutput.close();


        return {"path": tempFilePath};
    }
}
