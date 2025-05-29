package airpsx.service.script;
import sys.net.Socket;
import airpsx.utils.RuleScriptUtils;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.http.RequestStatic.socket;
import airpsx.type.ScriptType;
import airpsx.utils.ScriptUtils;

class ScriptExecutorService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var code = request.input("script");
        var type:ScriptType = request.input("type", ScriptType.RULESCRIPT);

        var socket:Socket = socket();
        socket.output.writeString("HTTP/1.1 200 OK\r\n");
        socket.output.writeString("\r\n");


        ScriptUtils.execute(code, type, socket.output);
        return null;
    }
}