package hx.well.handler.pkg;

import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;
import hx.well.http.ResponseBuilder;
import airpsx.pkg.PackageChunkVo;
import airpsx.pkg.PackageVo;
using airpsx.tools.OutputTools;

#if prospero
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
#end

// TODO: Handle sockets with better way
class UploadListPackageHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var sessionKey:String = request.query("sessionKey");
        trace("UploadPackageHandler: Listing uploaded chunks for session key " + sessionKey);

        var packageVo:PackageVo = PackageVo.current;
        trace(packageVo);
        if(packageVo == null || packageVo.sessionKey != sessionKey) {
            trace("UploadPackageHandler: Invalid session key.");
            return ResponseBuilder.asJson({
                status: "error",
                message: "Invalid session key."
            }).status(404);
        }

        var chunks:Array<PackageChunkVo> = packageVo.chunks.toArray();
        return ResponseBuilder.asJson({
            status: "success",
            sessionKey: sessionKey,
            chunks: chunks.map(packageChunkVo -> {key: packageChunkVo.key, start: packageChunkVo.start, end: packageChunkVo.end, createdAt: packageChunkVo.createdAt})
        });
    }
}