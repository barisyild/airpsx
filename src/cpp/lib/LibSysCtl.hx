package cpp.lib;

#if orbis
import utils.StringUtils;
import cpp.SizeT;
import cpp.extern.sys.ExternSysctl.ExternSysCtl;
import haxe.io.Bytes;
class LibSysCtl {
    @:hscriptVariable("sysctlbyname")
    public static function getByName<T>(key:String):Null<Bytes> {

        var valueSize:SizeT = getbyname_size(key);
        if(valueSize == -1)
            return null;

        var value:String = StringUtils.allocate(valueSize);
        ExternSysCtl.sysctlbyname(key, value, valueSize, null, 0);
        return Bytes.ofString(value);
    }

    private static inline function getbyname_size(key:String):SizeT
    {
        var size:SizeT = 0;
        if(ExternSysCtl.sysctlbyname(key, null, size, null, 0) == -1)
            return -1;

        return size;
    }
}
#end