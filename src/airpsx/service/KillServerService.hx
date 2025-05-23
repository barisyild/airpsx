package airpsx.service;

import sys.net.Socket;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.http.RequestStatic.socket;

// This service kill service process
class KillServerService extends AbstractService {
    public function new()
    {
        super();
    }

    public function execute(request:Request):AbstractResponse {
        var socket:Socket = socket();
        socket.write("HTTP/1.1 200 OK\r\n");
        socket.write("Content-Type: text/plain\r\n");
        socket.write("Connection: close\r\n");
        socket.write("\r\n");
        socket.write("OK");
        socket.close();

        trace("Server killed");
        AirPSX.exit(0);

        return null;
    }
}