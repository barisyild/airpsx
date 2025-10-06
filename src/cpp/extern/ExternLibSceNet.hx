package cpp.extern;

#if orbis
import cpp.Int32;
import cpp.UInt32;
import cpp.CastCharStar;
import cpp.ConstCharStar;
import cpp.SizeT;

@:keep
@:include('libSceNet.h')
extern class ExternLibSceNet {
    @:native("sceNetInit")
    public static function sceNetInit():Int32;

    @:native("sceNetTerm")
    public static function sceNetTerm():Int32;

    @:native("sceNetShowIfconfig")
    public static function sceNetShowIfconfig():Int32;

    @:native("sceNetShowNetstat")
    public static function sceNetShowNetstat():Int32;

    @:native("sceNetShowPolicy")
    public static function sceNetShowPolicy():Int32;

    @:native("sceNetShowRoute")
    public static function sceNetShowRoute():Int32;

    @:native("sceNetShowRoute6")
    public static function sceNetShowRoute6():Int32;

    @:native("sceNetConfigRoutingShowRoutingConfig")
    public static function sceNetConfigRoutingShowRoutingConfig():Int32;

    @:native("sceNetConfigRoutingShowtCtlVar")
    public static function sceNetConfigRoutingShowtCtlVar():Int32;

    @:native("sceNetShowNetstatForBuffer")
    public static function sceNetShowNetstatForBuffer(buffer:CastCharStar, size:cpp.SizeT):Void;
}

@:native('SceNetIfconfigInfo')
@:structAccess
extern class SceNetIfconfigInfo {
    public var size:UInt32;
    public var ip_address:CastCharStar;

    public static inline function create():SceNetIfconfigInfo {
        return untyped __cpp__('{}');
    }
}
#end