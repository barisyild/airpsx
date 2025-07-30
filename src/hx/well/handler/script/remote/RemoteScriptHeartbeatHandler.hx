package hx.well.handler.script.remote;
import hx.well.http.AbstractResponse;
import hx.well.http.Request;
import hx.well.handler.AbstractHandler;
class RemoteScriptHeartbeatHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        RemoteScriptExecuteHandler.updateHeartbeat();
        return {status: "success"};
    }
}