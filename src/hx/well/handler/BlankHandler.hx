package hx.well.handler;

import sys.net.Socket;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using airpsx.tools.StringTools;
using StringTools;


class BlankHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        return {data: ""};
    }
}