package cpp.lib;

#if orbis
import cpp.extern.ExternLibSceSystemService;
import cpp.extern.ExternLibSceSystemService.LncAppParamStruct;
import cpp.Pointer;
class LibSceSystemService {
    @:hscriptVariable("sceLncUtilLaunchApp")
    public static function lncUtilLaunchApp(titleId:String, ?userId:Int, appOpt:Int = 0, crashReport:Int = 0, checkFlag:LncAppParamFlag = LncAppParamFlag.Flag_None) {
        if(userId == null)
        {
            var userIdList:Array<Int> = LibSceUserService.getLoginUserIdList();
            userId = userIdList[0];
        }

        var param:LncAppParamStruct = LncAppParamStruct.create();
        param.sz = LncAppParamStruct.size();
        param.user_id = userId;
        param.app_opt = appOpt;
        param.crash_report = crashReport;
        param.check_flag = checkFlag; //Flag_None

        return ExternLibSceSystemService.sceLncUtilLaunchApp(titleId, null, param);
    }

    @:hscriptVariable("sceSystemServiceLaunchWebBrowser")
    public static function systemServiceLaunchWebBrowser(url:String):Bool
    {
        return ExternLibSceSystemService.sceSystemServiceLaunchWebBrowser(url) == 0;
    }
}
#end