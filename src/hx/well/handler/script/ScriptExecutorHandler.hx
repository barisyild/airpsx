package hx.well.handler.script;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import airpsx.type.ScriptType;
import airpsx.utils.ScriptUtils;

class ScriptExecutorHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var code = request.input("script");
        var type:ScriptType = request.input("type", ScriptType.RULESCRIPT);

        request.context.beginWrite();
        ScriptUtils.execute(code, type, request.context.output);
        return null;
    }
}