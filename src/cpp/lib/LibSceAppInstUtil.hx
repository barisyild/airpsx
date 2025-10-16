package cpp.lib;

#if orbis
import cpp.extern.ExternLibSceAppInstUtil;
import cpp.extern.ExternLibSceBgft;
import cpp.extern.ExternLibSceBgft.BgftDownloadParamEx;

@:include('libSceBgft.h')
class LibSceAppInstUtil {
    public static function initialize() {
        return ExternLibSceAppInstUtil.sceAppInstUtilInitialize() == 0;
    }

    public static function terminate():Bool {
        return ExternLibSceAppInstUtil.sceAppInstUtilTerminate() == 0;
    }

    @:hscriptVariable("appInstUtilInstallByPackage")
    public static function appInstUtilInstallByPackage(uri:String, contentName:String = "PKG", iconUrl:String = "") {
        #if prospero
        var arg3:PlayGoInfo = PlayGoInfo.create();

        var pkg_info:SceAppInstallPkgInfo = SceAppInstallPkgInfo.create();

        var inx:MetaInfo = MetaInfo.create();
        inx.uri = uri;
        inx.ex_uri = "";
        inx.playgo_scenario_id = "";
        inx.content_id = "";
        inx.content_name = contentName;
        inx.icon_url = iconUrl;

        ExternLibSceAppInstUtil.sceAppInstUtilInstallByPackage(inx, pkg_info, arg3);
        #else
        var downloadParams:BgftDownloadParamEx = BgftDownloadParamEx.create();
        downloadParams.param = BgftDownloadParam.create();
        downloadParams.param.entitlement_type = 5;
        downloadParams.param.id = "";
        downloadParams.param.content_url = uri;
        downloadParams.param.content_name = contentName;
        downloadParams.param.icon_path = "";
        downloadParams.param.playgo_scenario_id = "0";
        downloadParams.param.option = ExternLibSceBgft.BGFT_TASK_OPTION_DISABLE_CDN_QUERY_PARAM;
        downloadParams.slot = 0;
        var taskId:Int = ExternLibSceBgft.BGFT_INVALID_TASK_ID;
        var ret:Int = ExternLibSceBgft.sceBgftServiceIntDebugDownloadRegisterPkg(downloadParams.param, taskId);
        if (ret != 0) {
            trace("sceBgftServiceIntDebugDownloadRegisterPkg failed: " + ret);
        } else {
            trace("Task ID: 0x" + StringTools.hex(taskId, 8));
            ret = ExternLibSceBgft.sceBgftServiceIntDownloadStartTask(taskId);
            if (ret != 0) {
                trace("sceBgftServiceIntDownloadStartTask failed: " + ret);
            }
        }
        #end
    }

    @:hscriptVariable("sceAppInstUtilAppUnInstall")
    public static function appInstUtilAppUnInstall(titleId:String) {
        return ExternLibSceAppInstUtil.sceAppInstUtilAppUnInstall(titleId);
    }
}
#end