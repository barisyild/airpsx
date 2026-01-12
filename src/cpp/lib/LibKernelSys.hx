package cpp.lib;
#if orbis
import cpp.extern.ExternLibKernel.ExternLibKernel;
import cpp.extern.ExternLibKernelSys;
import cpp.extern.ExternLibKernel;
import airpsx.utils.StringUtils;

class LibKernelSys {
    public static function load():Void {
        var kernel_sys = ExternLibKernel.sceKernelLoadStartModule("/system/common/lib/libkernel_sys.sprx", 0, null, 0, null, null);
        ExternLibKernel.sceKernelDlsym(kernel_sys, 'sceKernelGetHwModelName', untyped __cpp__('(void **)&{0}', ExternLibKernelSys.sceKernelGetHwModelName));
        ExternLibKernel.sceKernelDlsym(kernel_sys, 'sceKernelGetHwSerialNumber', untyped __cpp__('(void **)&{0}', ExternLibKernelSys.sceKernelGetHwSerialNumber));
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
}
#end