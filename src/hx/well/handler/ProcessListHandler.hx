package hx.well.handler;
import sys.net.Socket;
import cpp.lib.Process;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;

// WIP
class ProcessListHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        #if orbis
        return Process.getProcessList();
        #else
        return {};
        #end
    }
}
