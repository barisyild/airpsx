package airpsx.pkg;
import haxe.Int64;
import hx.concurrent.collection.SynchronizedArray;

class PackageVo {
    public static var current:Null<PackageVo> = null;

    // UUID
    public var sessionKey:String;

    public var fileSize:Int64;

    public var lastAccessTime:Float = Sys.time();

    public var chunks:SynchronizedArray<PackageChunkVo> = new SynchronizedArray([]);

    public function new() {

    }

    public function check():Bool {
        for(chunk in chunks) {
            trace(chunk.key);
            if(!chunk.check())
            {
                trace(chunk.key, "failed!");
                return false;
            }

            lastAccessTime = Sys.time();
        }

        return lastAccessTime + 120 >= Sys.time();
    }

    public function dispose():Void {
        if(PackageVo.current == this)
            PackageVo.current = null;

        for(chunk in chunks) {
            chunk.dispose();
        }
        chunks = null;
    }
}
