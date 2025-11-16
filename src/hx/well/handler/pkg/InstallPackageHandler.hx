package hx.well.handler.pkg;
import hx.well.handler.AbstractHandler;
import hx.well.http.AbstractResponse;
import hx.well.http.Request;
import sys.FileSystem;
import cpp.lib.LibSceAppInstUtil;
using StringTools;

class InstallPackageHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var path:String = request.post("path");
        if(!path.startsWith("http") && !FileSystem.exists(path)) {
            return {
                status: "error",
                message: "File not found",
            }
        }

        #if orbis
        LibSceAppInstUtil.appInstUtilInstallByPackage(path);
        #end

        return  {
            status: "success"
        }
    }
}