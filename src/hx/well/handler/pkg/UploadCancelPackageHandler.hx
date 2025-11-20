package hx.well.handler.pkg;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import airpsx.pkg.PackageVo;
import hx.well.http.ResponseStatic.abort;
import hx.well.http.ResponseBuilder;

class UploadCancelPackageHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var sessionKey:String = request.post("sessionKey");
        var packageVo:PackageVo = PackageVo.current;
        if(packageVo.sessionKey != sessionKey)
            abort(404);

        packageVo.dispose();

        return ResponseBuilder.asJson({
            status: "success"
        });
    }
}