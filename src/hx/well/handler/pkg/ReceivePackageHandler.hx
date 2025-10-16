package hx.well.handler.pkg;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import haxe.Int64;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import hx.well.http.ResponseStatic;
import hx.well.http.ResponseStatic.abort;
import airpsx.pkg.PackageVo;
import airpsx.command.ServePackageCommand;
import sys.io.FileInput;
import sys.io.File;
import hx.well.http.ResponseBuilder;
import hx.well.http.encoding.EmptyEncodingOptions;
using airpsx.tools.InputTools;

class ReceivePackageHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var staticResponse = ResponseBuilder.asStatic();
        // Disable chunked encoding for package streaming
        staticResponse.encodingOptions = new EmptyEncodingOptions();

        var sessionKey:String = request.route("sessionKey");
        var range:String = request.header("Range");

        var packageVo:PackageVo = ServePackageCommand.packageVo;
        if(packageVo == null || packageVo.sessionKey != sessionKey)
            abort(500, "Session not found");

        var metadata:Bytes = packageVo.metadata;
        var fileSize:Int64 = packageVo.fileSize;

        if(range != null) {
            // Package Virtual Object
            var predataOffset:Int64 = packageVo.predataOffset;


            packageVo.lastAccessTime = Sys.time();

            // TODO: Move this range concept to another class
            var rangeSplit:Array<String> = range.split('=')[1].split('-');
            var rangeStart:Int64 = Int64.parseString(rangeSplit[0]);
            var rangeEnd:Null<Int64> = rangeSplit[1] == "" ? null : Int64.parseString(rangeSplit[1]);
            if(rangeEnd == null)
                rangeEnd = rangeStart + (1024 * 1024 * 5);

            // Set attributes for accessing with serve package thread
            request.setAttribute("start", rangeStart);
            request.setAttribute("end", rangeEnd);

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
                return ResponseBuilder
                    .asInput(fileInput.range(start, end), size)
                    .status(206)
                    .header("Content-Range", 'bytes ${rangeStart}-${rangeEnd}/${fileSize}');
            }

            // Handle in memory data
            if(rangeStart < metadata.length) {
                trace('read from cache: ${rangeStart}-${rangeEnd}');
                var start:Int = cast rangeStart;
                var end:Int = cast Math.min(cast rangeEnd, metadata.length - 1);
                var length:Int = end - start + 1;

                return ResponseBuilder
                    .asInput(new BytesInput(metadata.sub(start, length)), length)
                    .status(206)
                    .header("Content-Range", 'bytes ${start}-${rangeEnd}/${fileSize}');
            }

            // Handle in socket data
            packageVo.requests.add(request);

            // Manage the socket manually without closing it
            return ResponseBuilder.asAsync();
        }

        return ResponseBuilder
            .asInput(new BytesInput(metadata), fileSize)
            .header("Accept-Ranges", "bytes")
            .header("Content-Type", "application/octet-stream");
    }
}