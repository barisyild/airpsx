package cpp.lib;

#if orbis
import cpp.extern.ExternLibSceRegMgr;
import cpp.Int32;
import cpp.lib.type.RegMgrKey;
import haxe.crypto.Base64;
import haxe.io.Bytes;

class LibSceRegMgr {
    @:hscriptVariable("sceRegMgrGetInt")
    public static function getInt(key:RegMgrKey):Int32 {
        var val:Int32 = -1;
        ExternLibSceRegMgr.sceRegMgrGetInt(key, val);
        return val;
    }

    @:hscriptVariable("sceRegMgrGetInt64")
    public static function getInt64(key:RegMgrKey):Int64 {
        var array = getBin(key, 8);
        var low = array[0] | array[1] << 8 | array[2] << 16 | array[3] << 24;
        var high = array[4] | array[5] << 8 | array[6] << 16 | array[7] << 24;
        return haxe.Int64.make(high, low);
    }

    @:hscriptVariable("sceRegMgrGetStr")
    public static function getStr(key:RegMgrKey, size:Int32):Null<String> {
        var val:String = null;
        ExternLibSceRegMgr.sceRegMgrGetStr(key, val, size);
        return val;
    }

    @:hscriptVariable("sceRegMgrGetBinBase64")
    public static function getBinBase64(key:RegMgrKey, size:Int32):Null<String> {
        var val:Array<cpp.UInt8> = new Array<cpp.UInt8>();
        val.resize(size);

        ExternLibSceRegMgr.sceRegMgrGetBin(key, val, val.length);
        return Base64.encode(Bytes.ofData(val));
    }

    @:hscriptVariable("sceRegMgrGetBin")
    public static function getBin(key:RegMgrKey, size:Int32):Null<Array<cpp.UInt8>> {
        var val:Array<cpp.UInt8> = new Array<cpp.UInt8>();
        val.resize(size);

        ExternLibSceRegMgr.sceRegMgrGetBin(key, val, size);
        return val;
    }

    @:hscriptVariable("sceRegMgrSetInt")
    public static function setInt(key:RegMgrKey, val:Int32):Int32 {
        return ExternLibSceRegMgr.sceRegMgrSetInt(key, val);
    }

    @:hscriptVariable("sceRegMgrSetBin")
    public static function setBin(key:RegMgrKey, val:Array<cpp.UInt8>):Int32 {
        return ExternLibSceRegMgr.sceRegMgrSetBin(key, val, val.length);
    }

    @:hscriptVariable("sceRegMgrSetStr")
    public static function setStr(key:RegMgrKey, val:String):Int32 {
        return ExternLibSceRegMgr.sceRegMgrSetStr(key, val, val.length);
    }

    @:hscriptVariable("customRegMgrGenerateNum")
    public static function generateNum(a, b, c, d, e):RegMgrKey {
        return cast ((a < 1 || a > b) ? e : (a - 1) * c + d);
    }
}
#end