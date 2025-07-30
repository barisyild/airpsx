package hx.well.handler;

import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.http.ResponseBuilder;

// This service kill service process
class KillServerHandler extends AbstractHandler {
    public function new()
    {
        super();
    }

    public function execute(request:Request):AbstractResponse {
        var responseStatic = ResponseBuilder.asStatic();
        responseStatic.header("Content-Type", "text/plain");
        responseStatic.header("Connection", "close");
        var context = request.context;
        context.beginWrite();
        context.writeString("OK");
        context.close();

        trace("Server killed");
        AirPSX.exit(0);

        return null;
    }
}