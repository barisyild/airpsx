package airpsx.service.task;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileSeek;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using airpsx.tools.ResultSetTools;
import hx.well.http.RequestStatic.request;
import hx.well.validator.ValidatorRule;

class TaskLogService extends AbstractService {
    public function validator():Bool {
        return request().validate([
            "id" => [ValidatorRule.Required, ValidatorRule.Int]
        ]);
    }

    public function execute(request:Request):AbstractResponse {
        var id:Int = request.input("id");
        var logPath:String = '${Config.DATA_PATH}/task/${id}.log';
        if(!FileSystem.exists(logPath))
            return "";

        // Specify how many bytes to read
        var bytesToRead:Int = 100000;

        try {
            var fileSize = FileSystem.stat(logPath).size;
            // Calculate location to start reading
            var startPosition = cast Math.max(0, fileSize - bytesToRead);

            // read file with FileInput
            var input: FileInput = File.read(logPath);
            input.seek(startPosition, FileSeek.SeekBegin);

            return input;
        } catch (e: Dynamic) {
            trace("An error occurred: " + e);
        }

        return null;
    }
}