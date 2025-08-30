package hx.well.handler.script.remote;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import hx.well.http.ResponseStatic.abort;
import haxe.crypto.Md5;
import haxe.io.Bytes;
import hx.well.handler.filesystem.AbstractHttpFileStreamHandler;
import sys.io.File;
import sys.FileSystem;
import airpsx.Const;

class RemoteScriptImageHandler extends AbstractHttpFileStreamHandler {

    public override function execute(request:Request):AbstractResponse {
        var key:String = request.route("key");
        var data:Array<Dynamic> = DBStatic.connection(DatabaseType.SCRIPT_DB).select('SELECT imageHash FROM scripts WHERE key = ?', key);
        if(data.length == 0)
            abort(404);

        var first:Dynamic = data[0];
        var hash:String = first.imageHash;

        var path:String = '${Const.SCRIPT_PATH}/${hash}';
        request.setAttribute("filePath", path);
        if(FileSystem.exists(path))
            return super.execute(request);

        downloadImage(key, hash);
        return super.execute(request);
    }

    public function filePath(request:Request):String {
        return request.getAttribute("filePath");
    }

    public function basePath():Null<String> {
        return null;
    }

    public function bufferSize():Int {
        return 1024 * 10;
    }

    public function contentType(request:Request):Null<String> {
        return "image/png";
    }

    public function isDownloadRequest(request:Request):Bool {
        return false;
    }

    private function downloadImage(key:String, hash:String):Void {
        var url:String = 'https://airpsx.com/scripts/${key}.png';
        trace("Downloading image: " + url);

        var bytes:Bytes = null;

        var http = new haxe.Http(url);
        http.onBytes = function(data) {
            bytes = data;
        }
        http.onStatus = function(status) {
            if(status != 200)
                throw 'HTTP error ${status}';
        }
        http.onError = function(e) {
            abort(500, e);
        }
        http.request(false);

        if(Md5.make(bytes).toHex() != hash)
            abort(500, "Hash mismatch");

        var imageFile:String = '${Const.SCRIPT_PATH}/${hash}';
        var tempImageFile:String = '${Const.TEMP_PATH}/${hash}';
        File.saveBytes(tempImageFile, bytes);
        FileSystem.rename(tempImageFile, imageFile);
    }
}