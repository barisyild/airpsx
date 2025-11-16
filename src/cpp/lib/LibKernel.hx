package cpp.lib;

#if orbis
import cpp.extern.ExternLibKernelSys;
import cpp.extern.ExternLibKernel;
import cpp.extern.ExternLibKernel.NotifyRequestStruct;
import airpsx.utils.StringUtils;
import cpp.Int32;
import cpp.PidT;
import cpp.extern.ApplicationCategoryType;
import cpp.extern.sys.ExternSyscall;
using StringTools;
using airpsx.tools.StringTools;
using airpsx.tools.IntegerTools;

class LibKernel {
    public static var cpuTemperature(get, never):Int;

    @:hscriptVariable("sceKernelGetCpuTemperature")
    public static function get_cpuTemperature():Int {
        var temperature:Int32 = 0;
        ExternLibKernel.sceKernelGetCpuTemperature(temperature);
        return temperature;
    }

    public static var cpuFrequency(get, never):Float;

    @:hscriptVariable("sceKernelGetCpuFrequency")
    public static function get_cpuFrequency():Float {
        return ExternLibKernel.sceKernelGetCpuFrequency();
    }

    @:hscriptVariable("sceKernelSendNotificationRequest")
    public static inline function sendNotificationRequest(message:String):Void {
        if(message == null)
            throw "Message is null!";

        if(message.length > 3075)
            throw "Message is too long!";

        var notifyRequest:NotifyRequestStruct = NotifyRequestStruct.create();
        notifyRequest.message.copyFrom(message);
        ExternLibKernel.sceKernelSendNotificationRequest(0, notifyRequest, NotifyRequestStruct.size(), 0);
    }

    @:hscriptVariable("sceKernelGetHwModelName")
    public static function getHwModelName():String
    {
        var hwModelName:String = StringUtils.allocate(20);
        ExternLibKernelSys.sceKernelGetHwModelName(hwModelName);
        return hwModelName.truncateAtNull();
    }

    @:hscriptVariable("sceKernelGetHwSerialNumber")
    public static function getHwSerialNumber():String
    {
        var hwSerialNumber:String = StringUtils.allocate(17);
        ExternLibKernelSys.sceKernelGetHwSerialNumber(hwSerialNumber);
        return hwSerialNumber.truncateAtNull();
    }

    @:hscriptVariable("sceKernelGetSocSensorTemperature")
    public static function getSocSensorTemperature(sensor:Int = 0):Int
    {
        var socSensorTemperature:Int32 = 0;
        ExternLibKernel.sceKernelGetSocSensorTemperature(sensor, socSensorTemperature);
        return socSensorTemperature;
    }

    @:hscriptVariable("sceKernelGetAppInfo")
    public static function getAppInfo(pid:PidT):AppInfoTypedef
    {
        var appInfo:AppInfoStruct = AppInfoStruct.create();
        ExternLibKernel.sceKernelGetAppInfo(pid, appInfo);
        return {appID: appInfo.appID, titleID: appInfo.titleID, unknown1: appInfo.unknown1, unknown2: appInfo.unknown2};
    }

    public static function setProcessName(name:String):Int
    {
        ExternSyscall.syscall(ExternSyscall.SYS_thr_set_name, -1, "AirPSX");
        return 0;
    }

    #if prospero
    @:hscriptVariable("sceKernelGetAppCategoryType")
    public static function getAppCategoryType(pid:PidT):ApplicationCategoryType
    {
        var categoryType:ApplicationCategoryType = -1;
        ExternLibKernel.sceKernelGetAppCategoryType(pid, categoryType);
        return categoryType;
    }
    #end
}
#else
class LibKernel {
    @:hscriptVariable("sceKernelSendNotificationRequest")
    public static inline function sendNotificationRequest(message:String):Void {
        trace("Notification: " + message);
    }
}
#end