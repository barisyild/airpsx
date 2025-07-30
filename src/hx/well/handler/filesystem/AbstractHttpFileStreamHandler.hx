package hx.well.handler.filesystem;

import sys.io.FileInput;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;
import hx.well.http.ResponseStatic.*;
import hx.well.http.Response;
import hx.well.http.ResponseBuilder;
using airpsx.tools.InputTools;

abstract class AbstractHttpFileStreamHandler extends AbstractHandler {
    public function new() {
        super();
    }

    public function fileName(request:Request):String {
        return null;
    }

    public abstract function filePath(request:Request):String;

    public abstract function basePath():Null<String>;

    public abstract function bufferSize():Int;

    public abstract function contentType(request:Request):Null<String>;

    public abstract function isDownloadRequest(request:Request):Bool;

    public function execute(request:Request):AbstractResponse {
        var filePath:String = filePath(request);
        filePath = Path.normalize(filePath);

        var basePath:Null<String> = basePath();
        if(basePath != null && !filePath.startsWith(basePath))
        {
            return "Invalid file path";
        }

        if(!FileSystem.exists(filePath))
        {
            trace('File not found: ${filePath}');
            return "File not found";
        }

        var fileName:String = this.fileName(request) ?? filePath.substr(filePath.lastIndexOf("/") + 1);
        var fileInput:FileInput = File.read(filePath, true);

        var range:String = request.header("Range");
        if(range != null)
        {
            var fileSize:Int = FileSystem.stat(filePath).size;

            var rangeSplit:Array<String> = range.split('=')[1].split('-');
            var rangeStart:Int = Std.parseInt(rangeSplit[0]);
            var rangeEnd:Null<Int> = rangeSplit[1] == "" ? null : Std.parseInt(rangeSplit[1]);
            if(rangeEnd == null)
                rangeEnd = rangeStart + (1024 * 1024 * 5);
            if(rangeEnd >= fileSize) {
                rangeEnd = fileSize;
            }

            if(rangeStart > rangeEnd) {
                return "Invalid range";
            }

            var partialSize:Int = rangeEnd - rangeStart;
            return ResponseBuilder
                .asInput(fileInput.range(rangeStart, rangeEnd), partialSize)
                .status(206)
                .header("Content-Range", 'bytes ${rangeStart}-${rangeEnd-1}/${fileSize}');
        }

        var response:Response = ResponseBuilder
            .asFileInput(fileInput)
            .header("Content-Disposition", '${isDownloadRequest(request) ? 'attachment; ' : ''}filename=\"${fileName}\"');

        var contentType:String = contentType(request);
        if(contentType != null)
            response.header("Content-Type", contentType);

        return response;
    }
}
