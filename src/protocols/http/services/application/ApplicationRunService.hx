package protocols.http.services.application;

#if orbis
import sys.net.Socket;
import lib.LibSceSystemService;
import protocols.http.HTTPRequest;
using StringTools;

class ApplicationRunService extends AbstractHttpService {

    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var titleId:String = request.path.replace("/api/app/run/", "");
        var regex = new EReg("^[A-Z]{4}[0-9]{5}$", "");
        if(!regex.match(titleId))
            return {code: -1};

        var resultCode = LibSceSystemService.lncUtilLaunchApp(titleId);
        return {code: resultCode};
    }
}
#end