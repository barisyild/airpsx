package cpp.lib;

#if orbis
import cpp.extern.ExternLibSceAppInstUtil;
class LibSceAppInstUtil {
    public static function initialize() {
        return ExternLibSceAppInstUtil.sceAppInstUtilInitialize() == 0;
    }

    @:hscriptVariable("appInstUtilInstallByPackage")
    public static function appInstUtilInstallByPackage(uri:String, contentName:String = "PKG", iconUrl:String = "") {
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
    }

    @:hscriptVariable("sceAppInstUtilAppUnInstall")
    public static function appInstUtilAppUnInstall(titleId:String) {
        return ExternLibSceAppInstUtil.sceAppInstUtilAppUnInstall(titleId);
    }
}
#end