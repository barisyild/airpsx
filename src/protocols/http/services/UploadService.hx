package protocols.http.services;
import sys.net.Socket;
import protocols.http.HTTPRequest;


// WIP
@:stream
class UploadService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        return null;
    }
}
