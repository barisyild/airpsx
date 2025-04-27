package cpp.extern;

#if orbis
@:keep
@:include('libSceAppInstUtil.h')
@:build(Linc.touch())
@:build(Linc.xml('libSceAppInstUtil'))
extern class ExternLibSceAppInstUtil {
    @:native('sceAppInstUtilInitialize')
    public static function sceAppInstUtilInitialize():Int32;

    @:native('sceAppInstUtilAppUnInstall')
    public static function sceAppInstUtilAppUnInstall(titleId:ConstCharStar):Int32;

    @:native('sceAppInstUtilInstallByPackage')
    public static function sceAppInstUtilInstallByPackage(arg1:AbstractPointer<MetaInfo>, pkg_info:AbstractPointer<SceAppInstallPkgInfo>, arg2:AbstractPointer<PlayGoInfo>):Int32;
}

@:native('SceAppInstallPkgInfo')
@:structAccess
extern class SceAppInstallPkgInfo {
    public var content_id:CastCharStar;
    public var content_type:cpp.Int32;
    public var content_platform:cpp.Int32;

    public static inline function create():SceAppInstallPkgInfo {
        return untyped __cpp__('{}');
    }
}

@:native('MetaInfo')
@:structAccess
extern class MetaInfo {
    public var uri:ConstCharStar;
    public var ex_uri:ConstCharStar;
    public var playgo_scenario_id:ConstCharStar;
    public var content_id:ConstCharStar;
    public var content_name:ConstCharStar;
    public var icon_url:ConstCharStar;

    public static inline function create():MetaInfo {
        return untyped __cpp__('{}');
    }
}

@:native('PlayGoInfo')
@:structAccess
extern class PlayGoInfo {
    public var languages:CastCharStar;
    public var playgo_scenario_ids:CastCharStar;
    public var content_ids:CastCharStar;
    public var unknown:CastCharStar;

    public static inline function create():PlayGoInfo {
        return untyped __cpp__('{}');
    }
}
#end