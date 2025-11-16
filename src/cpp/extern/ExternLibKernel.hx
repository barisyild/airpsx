package cpp.extern;

#if orbis
import cpp.Pointer;
import cpp.SizeT;
import cpp.PidT;
import cpp.Int32;
import cpp.Int64;
import cpp.UInt32;
import cpp.UInt64;
import cpp.ConstCharStar;
import cpp.CastCharStar;
import cpp.Int32Pointer;
import cpp.AbstractPointer;
import cpp.extern.sys.ExternTimeSpec.TimeSpecStruct;

@:keep
@:include('libkernel.h')
extern class ExternLibKernel {
    @:native('sceKernelGetCpuFrequency')
    public static function sceKernelGetCpuFrequency():Float;

    @:native('sceKernelGetCpuTemperature')
    public static function sceKernelGetCpuTemperature(pointer:Int32Pointer):Int32;

    @:native('sceKernelGetSocSensorTemperature')
    public static function sceKernelGetSocSensorTemperature(val1:Int32, val2:Int32Pointer):Int32;

    @:native('sceKernelSendNotificationRequest')
    public static function sceKernelSendNotificationRequest(val1:Int32, notify_request:AbstractPointer<NotifyRequestStruct>, size_t:SizeT, val2:Int32):Int32;

    //extern "C" int int sceKernelGetAppInfo(pid_t pid, app_info_t *info);
    @:native('sceKernelGetAppInfo')
    public static function sceKernelGetAppInfo(pid:PidT, app_info:AbstractPointer<AppInfoStruct>):Int32;

    @:native("sceKernelGetAppCategoryType")
    public static function sceKernelGetAppCategoryType(pid:PidT, categoryType:Int32Pointer):Int32;

    @:native('kernel_get_ucred_authid')
    public static function kernel_get_ucred_authid(pid:PidT):Int64;

    @:native('kernel_set_ucred_authid')
    public static function kernel_set_ucred_authid(pid:PidT, authid:Int64):Int32;

    @:native('sceKernelLoadStartModule')
    public static function sceKernelLoadStartModule(name:ConstCharStar, argc:UInt64, argv:Int32, flags:UInt32, void:Int32, result:Int32):Pointer<cpp.Void>;

    @:native('sceKernelClockGettime')
    public static function sceKernelClockGettime(clock_id:ClockIdT, timeVal:AbstractPointer<TimeSpecStruct>):Int32;

    // char *argv[]
    @:native('getargv')
    public static function getargv():Pointer<cpp.Char>;

    @:native('getargc')
    public static function getargc():Pointer<cpp.Int32>;
}

@:keep
@:include('libkernel.h')
@:native('app_info')
@:structAccess
@:unreflective
extern class AppInfoStruct {
    public static inline function create(): AppInfoStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(AppInfoStruct);
    }

    @:native('app_id')
    public var appID:UInt32;

    @:native('unknown1')
    public var unknown1:UInt64;

    @:native('title_id')
    public var titleID:ConstCharStar;

    @:native('unknown2')
    public var unknown2:ConstCharStar;
}

typedef AppInfoTypedef = {
    var appID:UInt32;
    var unknown1:UInt64;
    var titleID:String;
    var unknown2:String;
}

@:keep
@:include('libkernel.h')
@:native('notify_request')
@:structAccess
@:unreflective
extern class NotifyRequestStruct {
    public static inline function create(): NotifyRequestStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(NotifyRequestStruct);
    }

    public var useless1:CastCharStar;
    public var message:CastCharStar;
}
#end