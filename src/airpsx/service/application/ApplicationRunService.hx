package airpsx.service.application;

#if orbis
import lib.LibSceSystemService;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;

class ApplicationRunService extends AbstractService {

    public function execute(request:Request):AbstractResponse {
        var titleId:String = request.route("titleId");
        var resultCode = LibSceSystemService.lncUtilLaunchApp(titleId);
        return {code: resultCode};
    }
}
#end