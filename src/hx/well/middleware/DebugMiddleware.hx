package hx.well.middleware;
import hx.well.http.Response;
import hx.well.http.Request;
import hx.well.type.AttributeType;
class DebugMiddleware extends AbstractMiddleware {
    public function handle(request:Request, next:(Request) -> Null<Response>):Null<Response> {
        request.setAttribute(AttributeType.AllowDebug, true);
        return next(request);
    }
}