package hx.well.handler.pkg;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import haxe.Int64;
import hx.well.http.ResponseStatic.abort;
import airpsx.pkg.PackageVo;
import hx.well.http.ResponseBuilder;
import hx.well.http.encoding.EmptyEncodingOptions;
import airpsx.pkg.PackageChunkVo;
import uuid.Uuid;

using airpsx.tools.InputTools;

class ReceivePackageHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var staticResponse = ResponseBuilder.asStatic();
        // Disable chunked encoding for package streaming
        staticResponse.encodingOptions = new EmptyEncodingOptions();

        var sessionKey:String = request.route("sessionKey");
        var range:String = request.header("Range");

        var packageVo:PackageVo = PackageVo.current;
        if(packageVo == null || packageVo.sessionKey != sessionKey)
            abort(500, "Session not found");

        if(range != null) {
            // Package Virtual Object
            packageVo.lastAccessTime = Sys.time();

            var rangeSplit:Array<String> = range.split('=')[1].split('-');
            var rangeStart:Int64 = Int64.parseString(rangeSplit[0]);
            var rangeEnd:Null<Int64> = rangeSplit[1] == "" ? null : Int64.parseString(rangeSplit[1]);
            if(rangeEnd == null)
                rangeEnd = rangeStart + 65536;

            var packageChunkVo = new PackageChunkVo(Uuid.nanoId(32), request.context);
            packageChunkVo.start = rangeStart;
            packageChunkVo.end = rangeEnd;

            // Handle in socket data
            packageVo.chunks.add(packageChunkVo);

            // Manage the socket manually without closing it
            return ResponseBuilder.asAsync();
        }

        var packageChunkVo = new PackageChunkVo(Uuid.nanoId(32), request.context);
        packageChunkVo.start = 0;
        packageChunkVo.end = 65536;

        // Handle in socket data
        packageVo.chunks.add(packageChunkVo);

        return ResponseBuilder.asAsync();
    }
}