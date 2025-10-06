package cpp.extern;

#if orbis
import cpp.ConstCharStar;
import cpp.CastCharStar;
import cpp.Int32;
import cpp.SizeT;
import cpp.UInt32;
import cpp.UInt64;
import cpp.lib.LncAppParamFlag;
import cpp.AbstractPointer;
import cpp.AbstractArrayPointer;
import cpp.Pointer;
import cpp.lib.LncAppErrorType;

@:keep
@:include('libSceSystemService.h')
extern class ExternLibSceSystemService {
    // extern "C" int sceLncUtilLaunchApp(const char* tid, const char* argv[], LncAppParam* param);
    @:native('sceLncUtilLaunchApp')
    public static function sceLncUtilLaunchApp(tid:CastCharStar, argv:ConstCharStar, param:AbstractPointer<LncAppParamStruct>):LncAppErrorType;

    // int sceSystemServiceLaunchWebApp(const char* url, const char* param, unsigned int flags);
    @:native('sceSystemServiceLaunchWebApp')
    public static function sceSystemServiceLaunchWebApp(url:ConstCharStar):Int32;

    @:native('sceSystemServiceLaunchWebBrowser')
    public static function sceSystemServiceLaunchWebBrowser(url:ConstCharStar):Int32;
} //Empty

@:keep
@:include('libSceSystemService.h')
@:native('LncAppParam')
@:structAccess
@:unreflective
extern class LncAppParamStruct {
    public static inline function create(): LncAppParamStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(LncAppParamStruct);
    }

    public var sz:UInt32;
    public var user_id:UInt32;
    public var app_opt:UInt32;
    public var crash_report:UInt64;
    public var check_flag:LncAppParamFlag;
}
#end