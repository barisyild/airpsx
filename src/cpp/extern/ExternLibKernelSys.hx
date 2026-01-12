package cpp.extern;

#if orbis
import cpp.CastCharStar;
import cpp.ConstCharStar;

@:keep
@:include('libkernel_sys.h')
extern class ExternLibKernelSys {
    #if prospero @:native('sceKernelGetHwModelName') #else @:native('f_sceKernelGetHwModelName') #end
    public static function sceKernelGetHwModelName(char:CastCharStar):ConstCharStar;

    #if prospero @:native('sceKernelGetHwSerialNumber') #else @:native('f_sceKernelGetHwSerialNumber') #end
    public static function sceKernelGetHwSerialNumber(char:CastCharStar):ConstCharStar;
} //Empty
#end