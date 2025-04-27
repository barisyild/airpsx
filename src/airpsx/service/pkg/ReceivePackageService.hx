package airpsx.service.pkg;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.http.ResponseStatic.response;
import haxe.Int64;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import hx.well.http.ResponseStatic;
import hx.well.http.ResponseStatic.abort;
import airpsx.pkg.PackageVo;
import airpsx.command.ServePackageCommand;
import sys.io.FileInput;
import sys.io.File;
using airpsx.tools.InputTools;

class ReceivePackageService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var sessionKey:String = request.route("sessionKey");
        var range:String = request.header("Range");
        if(range != null) {
            // Package Virtual Object
            var packageVo:PackageVo = ServePackageCommand.packageVo;
            if(packageVo == null || packageVo.sessionKey != sessionKey)
                abort(500, "Session not found");

            var metadata:Bytes = packageVo.metadata;
            var predataOffset:Int64 = packageVo.predataOffset;
            var fileSize:Int64 = packageVo.fileSize;


            packageVo.lastAccessTime = Sys.time();

            // TODO: Move this range concept to another class
            var rangeSplit:Array<String> = range.split('=')[1].split('-');
            var rangeStart:Int64 = Int64.parseString(rangeSplit[0]);
            var rangeEnd:Null<Int64> = rangeSplit[1] == "" ? null : Int64.parseString(rangeSplit[1]);
            if(rangeEnd == null)
                rangeEnd = rangeStart + (1024 * 1024 * 5);

            // Set attributes for accessing with serve package thread
            request.attributes.set("start", rangeStart);
            request.attributes.set("end", rangeEnd);

            // Set headers
            ResponseStatic.header("Content-Type", "application/octet-stream");
            ResponseStatic.header("Accept-Ranges", "bytes");


            // Handle in disk data
            if(predataOffset != 0 && rangeStart >= predataOffset) {
                var start:Int = cast rangeStart - predataOffset;
                var end:Int = cast rangeEnd - predataOffset;
                var size:Int = end - start + 1;

                var fileInput:FileInput = File.read(packageVo.predataFilePath);
                trace('bytes ${rangeStart}-${rangeEnd}/${fileSize}');
                return response()
                    .asInput(fileInput.range(start, end), size)
                    .status(206)
                    .header("Content-Range", 'bytes ${rangeStart}-${rangeEnd}/${fileSize}');
            }

            // Handle in memory data
            if(rangeStart == 0) {
                trace('read from cache: ${rangeStart}-${rangeEnd}');

                return response()
                    .asInput(new BytesInput(metadata), metadata.length)
                    .status(206)
                    .header("Content-Range", 'bytes ${rangeStart}-${rangeStart + (metadata.length - 1)}/${fileSize}');
            }

            // Handle in socket data
            packageVo.requests.add(request);

            // Manage the socket manually without closing it
            return response().asManual();
        }

        return {
            status: "error"
        };
    }
}