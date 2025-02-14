package airpsx.service.application;

#if orbis
import sys.net.Socket;
import lib.LibSceSystemService;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;

class ApplicationRunService extends AbstractService {

    public function execute(request:Request):AbstractResponse {
        var titleId:String = request.path.replace("/api/app/run/", "");
        var regex = new EReg("^[A-Z]{4}[0-9]{5}$", "");
        if(!regex.match(titleId))
            return {code: -1};

        var resultCode = LibSceSystemService.lncUtilLaunchApp(titleId);
        return {code: resultCode};
    }
}
#end