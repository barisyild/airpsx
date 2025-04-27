package airpsx.service.pkg;
import hx.well.service.AbstractService;
import hx.well.http.AbstractResponse;
import hx.well.http.Request;
import sys.FileSystem;
import cpp.lib.LibSceAppInstUtil;
using StringTools;

class InstallPackageService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var path:String = request.post("path");
        if(!path.startsWith("http") && !FileSystem.exists(path)) {
            return {
                status: "error",
                message: "File not found",
            }
        }

        LibSceAppInstUtil.appInstUtilInstallByPackage(path);

        return  {
            status: "success"
        }
    }
}