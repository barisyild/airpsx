package cpp.lib;
import cpp.extern.ExternLibSceAppInstUtil;
class LibSceAppInstUtil {
    public static function initialize() {
        return ExternLibSceAppInstUtil.sceAppInstUtilInitialize() == 0;
    }

    @:hscriptVariable("sceAppInstUtilAppUnInstall")
    public static function appInstUtilAppUnInstall(titleId:String) {
        return ExternLibSceAppInstUtil.sceAppInstUtilAppUnInstall(titleId);
    }
}