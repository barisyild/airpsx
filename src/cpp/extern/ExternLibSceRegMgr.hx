package cpp.extern;

#if orbis
import cpp.Int32;
import cpp.Int64;
import cpp.AbstractArrayPointer;

@:keep
@:include('libSceRegMgr.h')
extern class ExternLibSceRegMgr {
    @:native('sceRegMgrGetInt')
    public static function sceRegMgrGetInt(key:Int64, val:AbstractPointer<Int32>):Int32;

    @:native('sceRegMgrGetStr')
    public static function sceRegMgrGetStr(key:Int64, val:CastCharStar, size:Int32):Int32;

    @:native('sceRegMgrGetBin')
    public static function sceRegMgrGetBin(key:Int64, val:AbstractArrayPointer<cpp.UInt8>, size:Int32):Int32;

    @:native('sceRegMgrSetInt')
    public static function sceRegMgrSetInt(key:Int64, val:Int32):Int32;

    @:native('sceRegMgrSetBin')
    public static function sceRegMgrSetBin(key:Int64, val:AbstractArrayPointer<cpp.UInt8>, size:Int32):Int32;

    @:native('sceRegMgrSetStr')
    public static function sceRegMgrSetStr(key:Int64, val:ConstCharStar, size:Int32):Int32;
}
#end