package externs.sys;

#if orbis
import cpp.Int64;
import cpp.ConstCharStar;
import cpp.SizeT;
import cpp.FsblkcntT;

@:keep
@:include('sys/statvfs.h')
extern class ExternStatvfs {

    @:native('statvfs')
    public static function statvfs(path:ConstCharStar, statStruct:cpp.AbstractPointer<StatVfsStruct>):Int64;

    @:native('statfs')
    public static function statfs(path:ConstCharStar, statStruct:cpp.AbstractPointer<StatVfsStruct>):Int64;
}

@:keep
@:include('sys/statvfs.h')
@:native('struct statvfs')
@:structAccess
@:unreflective
extern class StatVfsStruct {
    @:native('f_bavail')
    public var f_bavail:FsblkcntT;

    @:native('f_bfree')
    public var f_bfree:FsblkcntT;

    @:native('f_blocks')
    public var f_blocks:FsblkcntT;

    @:native('f_favail')
    public var f_favail:FsblkcntT;

    @:native('f_ffree')
    public var f_ffree:FsblkcntT;

    @:native('f_files')
    public var f_files:FsblkcntT;

    @:native('f_bsize')
    public var f_bsize:Int64;

    @:native('f_flag')
    public var f_flag:Int64;

    @:native('f_frsize')
    public var f_frsize:Int64;

    @:native('f_fsid')
    public var f_fsid:Int64;

    @:native('f_namemax')
    public var f_namemax:Int64;

    public static inline function create(): StatVfsStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(StatVfsStruct);
    }
}
#end