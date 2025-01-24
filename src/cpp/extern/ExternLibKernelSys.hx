package cpp.extern;

#if orbis
import cpp.CastCharStar;
import cpp.ConstCharStar;

@:keep
@:include('libkernel_sys.h')
@:build(Linc.touch())
@:build(Linc.xml('libkernel_sys'))
extern class ExternLibKernelSys {
    @:native('sceKernelGetHwModelName')
    public static function sceKernelGetHwModelName(char:CastCharStar):ConstCharStar;

    @:native('sceKernelGetHwSerialNumber')
    public static function sceKernelGetHwSerialNumber(char:CastCharStar):ConstCharStar;
} //Empty
#end