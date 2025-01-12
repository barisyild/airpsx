package protocols.http.services;
import sys.net.Socket;
import protocols.http.HTTPRequest;
class Api404Service extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        return "Page Not Found";
    }
}
