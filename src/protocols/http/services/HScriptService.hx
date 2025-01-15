package protocols.http.services;

import sys.net.Socket;
import cpp.Function;
import utils.RuleScriptUtils;
import protocols.http.HTTPRequest;

class HScriptService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var code = request.bodyBytes.toString();

        socket.output.writeString("HTTP/1.1 200 OK\n");
        socket.output.writeString("\n");

        RuleScriptUtils.execute(code, socket.output);

        return null;
    }
}
