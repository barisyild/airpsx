package protocols.http.services;

import sys.net.Socket;
import protocols.http.HTTPRequest;

// This service returns non-variable system resources.
class KillServerService extends AbstractHttpService {
    public function new()
    {
        super();
    }

    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
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