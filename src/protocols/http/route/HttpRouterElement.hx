package protocols.http.route;
import protocols.http.services.AbstractHttpService;
import haxe.http.HttpMethod;
import protocols.http.route.HttpRouterElement;

class HttpRouterElement {
    private var method:HttpMethod = HttpMethod.Get;
    private var path:String;
    private var handler:AbstractHttpService;
    private var stream:Bool;

    public function new() {

    }

    public inline function getMethod():HttpMethod {
        return method;
    }

    public function setMethod(method:HttpMethod):HttpRouterElement {
        this.method = method;
        return this;
    }

    public inline function getPath():String {
        return path;
    }

    public function setPath(path:String):HttpRouterElement {
        this.path = path;
        return this;
    }

    public inline function getHandler():AbstractHttpService {
        return handler;
    }

    public function setHandler(handler:AbstractHttpService):HttpRouterElement {
        this.handler = handler;
        return this;
    }

    public inline function getStream():Bool {
        return stream;
    }

    public function setStream(stream:Bool):HttpRouterElement {
        this.stream = stream;
        return this;
    }
}
