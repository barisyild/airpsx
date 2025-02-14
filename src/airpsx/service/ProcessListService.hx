package airpsx.service;
import sys.net.Socket;
import lib.Process;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;

// WIP
class ProcessListService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        #if orbis
        return Process.getProcessList();
        #else
        return {};
        #end
    }
}
