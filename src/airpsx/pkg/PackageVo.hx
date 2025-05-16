package airpsx.pkg;
import hx.well.http.Request;
import sys.thread.Mutex;
import haxe.Int64;
import sys.net.Socket;
import hx.concurrent.collection.SynchronizedArray;
import haxe.io.Bytes;
import sys.FileSystem;
class PackageVo {
    // UUID
    public var sessionKey:String;

    public var sourceSocket:Socket;

    public var requests:SynchronizedArray<Request> = new SynchronizedArray([]);

    public var mutex:Mutex = new Mutex();

    public var fileSize:Int64;

    public var predataOffset:Int64;

    public var pos:Int64 = 0;

    public var metadata:Bytes = null;

    public var lastAccessTime:Float = Sys.time();

    public var preDataDirectoryPath(get, never):String;
    private function get_preDataDirectoryPath():String {
        return '${Config.TEMP_PATH}/pkg';
    }

    public var predataFilePath(get, never):String;
    private function get_predataFilePath():String {
        return '${preDataDirectoryPath}/${this.sessionKey}';
    }

    public function new() {

    }

    public function dispose():Void {

        try {
            if(this.sourceSocket != null) {
                this.sourceSocket.close();
            }
        } catch (e) {
            trace(e);
        }

        var requests = this.requests;
        this.requests = null;

        for(request in requests) {
            try {
                request.socket.close();
            } catch (e) {
                trace(e);
            }
        }

        if(FileSystem.exists(predataFilePath))
            FileSystem.deleteFile(predataFilePath);
    }
}
