package protocols.http.services;
import sys.net.Socket;
import lib.Process;
import protocols.http.HTTPRequest;

// WIP
class ProcessListService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        #if orbis
        return Process.getProcessList();
        #else
        return {};
        #end
    }
}
