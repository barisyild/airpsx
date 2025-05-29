package airpsx.service.script.remote;
import hx.well.service.AbstractService;
import hx.well.http.AbstractResponse;
import hx.well.http.Request;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import hx.well.http.ResponseStatic.abort;
import cpp.lib.Systemctl;
import sys.FileSystem;
import airpsx.utils.RuleScriptUtils;
import airpsx.type.ScriptType;
import airpsx.utils.ResolveScript;
import sys.net.Socket;
import haxe.Exception;
import haxe.crypto.Md5;
import sys.io.File;
import airpsx.utils.ScriptUtils;

class RemoteScriptExecuteService extends AbstractService {
    public static var lastUpdateAt:Int = 0;

    public function execute(request:Request):AbstractResponse {
        updateHeartbeat();

        var socket:Socket = request.socket;

        var key:String = request.post("key");

        // 0.00 is debug build or github actions artifacts
        var versionQuery:String = (Config.VERSION == "0.00") ? "" : ' and version <= "${Config.VERSION}"';
        var data:Array<Dynamic> = DBStatic.connection(DatabaseType.SCRIPT_DB).select('SELECT key, scriptHash, type FROM scripts WHERE minFirmware <= ? AND maxFirmware >= ? and key = ?' + versionQuery, Systemctl.kernelSdkVersion, Systemctl.kernelSdkVersion, key);
        if(data.length == 0)
            abort(404, "Script not found");

        var first:Dynamic = data[0];
        trace("Executing script: " + first.key);

        var scriptType:ScriptType = cast first.type;
        var scriptHash:String = first.scriptHash;
        var scriptFile:String = '${Config.SCRIPT_PATH}/${scriptHash}';

        var extra:Map<String, Any> = ["checkHeartbeat" => checkHeartbeat];

        if(FileSystem.exists(scriptFile))
        {
            var scriptContent:String = sys.io.File.getContent(scriptFile);
            socket.output.writeString("HTTP/1.1 200 OK\r\n");
            socket.output.writeString("\r\n");
            ScriptUtils.execute(scriptContent, scriptType, request.socket.output, extra);
            return null;
        }

        var scriptContent:String = null;
        try {
            scriptContent = downloadScript(key, cast first.type, scriptHash);
            sys.io.File.saveContent(scriptFile, scriptContent);
        } catch (e:Exception) {
            trace(e);
            abort(500, e.message);
        }

        socket.output.writeString("HTTP/1.1 200 OK\r\n");
        socket.output.writeString("\r\n");
        ScriptUtils.execute(scriptContent, scriptType, request.socket.output, extra);
        return null;
    }

    private static function checkHeartbeat():Bool {
        return Math.floor(Sys.time()) - lastUpdateAt < 5;
    }

    public static function updateHeartbeat():Void {
        lastUpdateAt = Math.floor(Sys.time());
    }

    private function downloadScript(key:String, type:ScriptType, hash:String):String {
        var url:String = ResolveScript.resolveUrl(key, type);
        trace("Downloading script: " + url);

        var content:String = "";

        var http = new haxe.Http(url);
        http.onData = function(data) {
            content = data;
        }
        http.onStatus = function(status) {
            if(status != 200)
                throw "HTTP error: " + status;
        }
        http.onError = function(e) {
            throw e;
        }
        http.request(false);

        if(Md5.encode(content) != hash)
            throw "Hash mismatch";

        var scriptFile:String = '${Config.SCRIPT_PATH}/${hash}';
        var tempScriptFile:String = '${Config.TEMP_PATH}/${hash}';
        File.saveContent(tempScriptFile, content);
        FileSystem.rename(tempScriptFile, scriptFile);

        return content;
    }
}
