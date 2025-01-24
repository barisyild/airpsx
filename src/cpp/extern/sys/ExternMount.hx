package cpp.extern.sys;

#if orbis
import cpp.Int64;
import cpp.ConstCharStar;
import cpp.SizeT;

@:keep
@:include('sys/mount.h')
extern class ExternMount {
    @:native('statfs')
    public static function statfs(path:ConstCharStar, statStruct:cpp.AbstractPointer<StatFsStruct>):Int64;
}
@:keep
@:include('sys/mount.h')
@:native('struct statfs')
@:structAccess
@:unreflective
extern class StatFsStruct {
    @:native('f_fstypename')
    public var f_fstypename:ConstCharStar;

    public static inline function create(): StatFsStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(StatFsStruct);
    }
}
#end