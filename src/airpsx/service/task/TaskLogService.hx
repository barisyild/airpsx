package airpsx.service.task;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileSeek;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using tools.ResultSetTools;
import hx.well.http.RequestStatic.socket;

class TaskLogService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var jsonData:Dynamic = haxe.Json.parse(request.bodyBytes.toString());
        var id:Int = Std.parseInt(jsonData.id);
        var logPath:String = '${Config.DATA_PATH}/task/${id}.log';
        if(!FileSystem.exists(logPath))
            return "";

        // Kaç bayt okunacağını belirt
        var bytesToRead:Int = 100000;

        try {
            var fileSize = FileSystem.stat(logPath).size;
            // Okumaya başlanacak konumu hesapla
            var startPosition = cast Math.max(0, fileSize - bytesToRead);

            // FileInput ile dosyayı aç
            var input: FileInput = File.read(logPath);
            input.seek(startPosition, FileSeek.SeekBegin);

            return input;
        } catch (e: Dynamic) {
            trace("Bir hata oluştu: " + e);
        }

        return null;
    }
}