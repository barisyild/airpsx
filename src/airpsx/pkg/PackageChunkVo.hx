package airpsx.pkg;
import haxe.Int64;
import hx.well.http.driver.socket.SocketInput;
import hx.well.http.driver.IDriverContext;
class PackageChunkVo {
    public final key:String;
    public final context:IDriverContext;
    public final createdAt:Float;

    public var start:Int64 = 0;
    public var end:Int64 = 0;

    public var sourceContext:IDriverContext;

    private var lastRemainingBytes:Int;
    private var lastBytesUpdateTime:Float = Sys.time();

    public var fileSize(get, null):Int64;
    private function get_fileSize():Int64 {
        return this.end - this.start + 1;
    }

    private var i:Int = 0;

    public function new(key:String, context:IDriverContext) {
        this.key = key;
        this.context = context;
        this.createdAt = Sys.time();
    }

    public function check():Bool {
        // if sourceContext is null and 5 min pass
        if(sourceContext == null && createdAt + (60 * 5) >= Sys.time())
        {
            trace("FAIL_1");
            return true;
        }

        if(sourceContext != null) {
            var socketInput:SocketInput = cast sourceContext.input;

            if(lastRemainingBytes != socketInput.length)
            {
                lastRemainingBytes = socketInput.length;
                lastBytesUpdateTime = Sys.time();
                trace(key, lastRemainingBytes, i++);
            }else{
                trace(key, 'lastRemainingBytes == socketInput.length');
            }
        }

        return lastBytesUpdateTime + 30 >= Sys.time();
    }

    public function dispose():Void {

        closeContext(context);

        if(sourceContext != null)
            closeContext(sourceContext);
    }

    private function closeContext(context:IDriverContext):Void {
        try {
            context.close();
        } catch (e) {
            trace(e);
        }
    }
}
