package protocols.http.services.task;
import sys.net.Socket;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileSeek;
import cpp.Int64;
import protocols.http.HTTPRequest;
using tools.ResultSetTools;

class TaskLogService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var jsonData:Dynamic = haxe.Json.parse(request.bodyBytes.toString());
        var id:Int = Std.parseInt(jsonData.id);
        var logPath:String = '${Config.DATA_PATH}/task/${id}.log';
        if(!FileSystem.exists(logPath))
            return "";

        socket.write("HTTP/1.1 200 OK\n");
        socket.write("\n");

        // Kaç bayt okunacağını belirt
        var bytesToRead:Int = 100000;

        try {
            var fileSize = FileSystem.stat(logPath).size;
            // Okumaya başlanacak konumu hesapla
            var startPosition = cast Math.max(0, fileSize - bytesToRead);

            // FileInput ile dosyayı aç
            var input: FileInput = File.read(logPath);
            input.seek(startPosition, FileSeek.SeekBegin);

            // Byte'ları oku
            socket.output.writeInput(input);

            // Dosyayı kapat
            input.close();
        } catch (e: Dynamic) {
            trace("Bir hata oluştu: " + e);
        }

        return null;
    }
}