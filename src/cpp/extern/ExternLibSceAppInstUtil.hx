package cpp.extern;

/*@:keep
@:include('libSceAppInstUtil.h')
@:build(Linc.touch())
@:build(Linc.xml('libSceAppInstUtil'))
extern class ExternLibSceAppInstUtil {
    @:native('sceAppInstUtilInitialize')
    public static function sceAppInstUtilInitialize():Int32;

    @:native('sceAppInstUtilAppUnInstall')
    public static function sceAppInstUtilAppUnInstall(titleId:ConstCharStar):Int32;
}*/