package protocols.http.services.filesystem;

import sys.net.Socket;
import haxe.Int64;
import sys.io.FileInput;
import sys.io.File;
import haxe.io.Bytes;
import haxe.Exception;
import haxe.CallStack;
import sys.FileSystem;
import haxe.io.Path;
import sys.io.FileSeek;
import protocols.http.HTTPRequest;
using StringTools;

abstract class AbstractHttpFileStreamService extends AbstractHttpService {
    public function new() {
        super();
    }

    public abstract function filePath(request:HTTPRequest):String;

    public abstract function basePath():Null<String>;

    public abstract function bufferSize():Int;

    public abstract function contentType(request:HTTPRequest):Null<String>;

    public abstract function isDownloadRequest(request:HTTPRequest):Bool;

    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var filePath:String = filePath(request);
        filePath = Path.normalize(filePath);

        var basePath:Null<String> = basePath();
        if(basePath != null && !filePath.startsWith(basePath))
        {
            return "Invalid file path";
        }

        if(!FileSystem.exists(filePath))
        {
            trace('File not found: ${filePath}');
            return "File not found";
        }

        var fileName:String = filePath.substr(filePath.lastIndexOf("/") + 1);

        var totalBytes:Int64 = sys.FileSystem.stat(filePath).size;

        trace('File size: ${totalBytes}');

        socket.output.writeString("HTTP/1.1 200 OK\n");

        var contentType:String = contentType(request);
        if(contentType != null)
        {
            socket.output.writeString('Content-Type: ${contentType}\n');
        }

        socket.output.writeString('Content-Length: ${totalBytes}\n');

        writeHeaders(socket);
        if(isDownloadRequest(request))
        {
            socket.output.writeString('Content-Disposition: attachment; filename=\"${fileName}\"\n');
        }
        socket.output.writeString("\n");


        var fileInput:FileInput = File.read(filePath, true);
        //fileInput.seek(0, FileSeek.SeekBegin);

        var bufferSize:Int = bufferSize();
        while (!fileInput.eof() && totalBytes > 0)
        {
            bufferSize = Std.int(Math.min(bufferSize, cast totalBytes));

            var buffer:Bytes = fileInput.read(bufferSize);
            totalBytes -= buffer.length;
            try
            {
                socket.output.writeBytes(buffer, 0, buffer.length);
            }
            catch (e:Exception)
            {
                trace('Error writing to socket: ${e.message}\n${CallStack.toString(e.stack)}');
                break;
            }
        }
        fileInput.close();

        return null;
    }

    public function writeHeaders(socket:Socket):Void {

    }
}
