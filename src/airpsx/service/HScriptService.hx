package airpsx.service;

import sys.net.Socket;
import airpsx.utils.RuleScriptUtils;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.http.RequestStatic.socket;

class HScriptService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var code = request.input("script");

        var socket:Socket = socket();
        socket.output.writeString("HTTP/1.1 200 OK\r\n");
        socket.output.writeString("\r\n");

        RuleScriptUtils.execute(code, socket.output);

        return null;
    }
}
