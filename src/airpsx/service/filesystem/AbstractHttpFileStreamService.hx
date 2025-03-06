package airpsx.service.filesystem;

import sys.io.FileInput;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;
import hx.well.http.ResponseStatic.*;
import hx.well.http.Response;

abstract class AbstractHttpFileStreamService extends AbstractService {
    public function new() {
        super();
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

        var fileName:String = filePath.substr(filePath.lastIndexOf("/") + 1);
        var fileInput:FileInput = File.read(filePath, true);

        var response:Response = response()
            .asFileInput(fileInput)
            .header("Content-Disposition", 'filename=\"${fileName}\"');

        var contentType:String = contentType(request);
        if(contentType != null)
            response.header("Content-Type", contentType);

        return response;
    }
}
