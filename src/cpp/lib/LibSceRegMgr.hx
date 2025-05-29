package cpp.lib;

#if orbis
import cpp.extern.ExternLibSceRegMgr;
import cpp.Int32;
import cpp.lib.type.RegMgrKey;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import airpsx.utils.StringUtils;
import haxe.Int64;
using airpsx.tools.Integer64Tools;

@:nullSafety(StrictThreaded)
class LibSceRegMgr {
    @:hscriptVariable("sceRegMgrGetInt")
    public static function getInt(key:RegMgrKey):Null<Int32> {
        var val:Int32 = -1;
        if(ExternLibSceRegMgr.sceRegMgrGetInt(key, val) != 0)
            return null;
        return val;
    }

    @:hscriptVariable("sceRegMgrGetInt64")
    @:custom
    public static function getInt64(key:RegMgrKey):Null<Int64> {
        var array = getBin(key, 8);
        if(array == null)
            return null;

        var low = array[0] | array[1] << 8 | array[2] << 16 | array[3] << 24;
        var high = array[4] | array[5] << 8 | array[6] << 16 | array[7] << 24;
        return Int64.make(high, low);
    }

    @:hscriptVariable("sceRegMgrGetStr")
    public static function getStr(key:RegMgrKey, size:Int32):Null<String> {
        var val:String = StringUtils.allocate(size);

        if(ExternLibSceRegMgr.sceRegMgrGetStr(key, val, size) != 0)
            return null;

        return val;
    }

    @:hscriptVariable("sceRegMgrGetBinBase64")
    @:custom
    public static function getBinBase64(key:RegMgrKey, size:Int32):Null<String> {
        var bytes:Null<Bytes> = getBytes(key, size);
        if(bytes == null)
            return null;

        return Base64.encode(bytes);
    }

    @:hscriptVariable("sceRegMgrGetBytes")
    @:custom
    public static function getBytes(key:RegMgrKey, size:Int32):Null<Bytes> {
        var bin:Null<Array<cpp.UInt8>> = getBin(key, size);
        if(bin == null)
            return null;

        return Bytes.ofData(bin);
    }

    @:hscriptVariable("sceRegMgrSetInt")
    public static function setInt(key:RegMgrKey, val:Int32):Int32 {
        return ExternLibSceRegMgr.sceRegMgrSetInt(key, val);
    }

    @:hscriptVariable("sceRegMgrGetBin")
    public static function getBin(key:RegMgrKey, size:Int32):Null<Array<cpp.UInt8>> {
        var val:Array<cpp.UInt8> = new Array<cpp.UInt8>();
        val.resize(size);

        if(ExternLibSceRegMgr.sceRegMgrGetBin(key, val, size) != 0)
            return null;

        return val;
    }

    @:hscriptVariable("sceRegMgrSetInt64")
    @:custom
    public static function setInt64(key:RegMgrKey, val:Int64):Int32 {
        return setBin(key, val.toArray());
    }

    @:hscriptVariable("sceRegMgrSetBin")
    public static function setBin(key:RegMgrKey, val:Array<cpp.UInt8>, ?length:Int32):Int32 {
        if(length == null)
            length = val.length;
        return ExternLibSceRegMgr.sceRegMgrSetBin(key, val, length);
    }

    @:hscriptVariable("sceRegMgrSetStr")
    public static function setStr(key:RegMgrKey, val:String, ?length:Int32):Int32 {
        if(length == null)
            length = val.length;
        return ExternLibSceRegMgr.sceRegMgrSetStr(key, val, length);
    }

    @:hscriptVariable("customRegMgrGenerateNum")
    @:custom
    public static function generateNum(a, b, c, d, e):RegMgrKey {
        return cast ((a < 1 || a > b) ? e : (a - 1) * c + d);
    }
}
#end