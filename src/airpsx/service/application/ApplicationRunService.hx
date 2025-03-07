package airpsx.service.application;

#if orbis
import cpp.lib.LibSceSystemService;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import airpsx.tools.Integer64Tools;
import cpp.lib.LncAppErrorType;
using StringTools;

class ApplicationRunService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var titleId:String = request.route("titleId");
        var resultCode:LncAppErrorType = LibSceSystemService.lncUtilLaunchApp(titleId);

        var successResponse = {success: true, message: "Application started successfully"};

        if(!isError(resultCode))
            return successResponse;

        return switch (resultCode) {
            case SCE_LNC_ERROR_APP_NOT_FOUND:
                {success: false, message: "The application was not found"};
            case SCE_LNC_UTIL_ERROR_ALREADY_RUNNING:
                {success: false, message: "The application is already running"};
            case SCE_LNC_UTIL_ERROR_APPHOME_EBOOTBIN_NOT_FOUND:
                {success: false, message: "eboot.bin not found"};
            case SCE_LNC_UTIL_ERROR_APPHOME_PARAMSFO_NOT_FOUND:
                {success: false, message: "param.sfo not found"};
            case SCE_LNC_UTIL_ERROR_NO_SFOKEY_IN_APP_INFO:
                {success: false, message: "No SFO key in app info"};
            case SCE_LNC_UTIL_ERROR_SETUP_FS_SANDBOX:
                {success: false, message: "Failed to setup FS sandbox"};
            case SCE_LNC_UTIL_ERROR_INVALID_TITLE_ID:
                {success: false, message: "Invalid title ID"};
            case PROCCESS_STARTER_OP_NOT_SUPPORTED:
                {success: false, message: "Operation not supported"};
            case SCE_NP_TROPHY_ERROR_NPCOMMSIGN_NOT_FOUND:
                {success: false, message: "Trophy is encrypted and can't be used"};
            case SCE_PROCESS_STARTER_ERROR_PS4_BLACK_LIST:
                {success: false, message: "The PS4 application is blacklisted"};
            case SCE_LNC_UTIL_ERROR_ALREADY_RUNNING_KILL_NEEDED | SCE_LNC_UTIL_ERROR_ALREADY_RUNNING_SUSPEND_NEEDED:
                successResponse;
            default:
                {success: false, message: Integer64Tools.ofUInt(resultCode)};
        }
    }

    private function isError(ret:UInt):Bool {
        return ret & 0x80000000 != 0;
    }
}
#end