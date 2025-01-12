package lib.sys;

#if orbis
import externs.sys.ExternStatvfs.StatVfsStruct;
import externs.sys.ExternStatvfs;
import haxe.Int64;

class LibStatVfs {

    @:hscriptVariable("statvfs")
    public static function getStatVfs(path:String):Null<StatVFSTypedef>
    {
        var struct = StatVfsStruct.create();
        if(ExternStatvfs.statvfs(path, struct) == -1)
            return null;

        return {
            f_bavail: struct.f_bavail,
            f_bfree: struct.f_bfree,
            f_blocks: struct.f_blocks,
            f_favail: struct.f_favail,
            f_ffree: struct.f_ffree,
            f_files: struct.f_files,
            f_bsize: struct.f_bsize,
            f_flag: struct.f_flag,
            f_frsize: struct.f_frsize,
            f_fsid: struct.f_fsid,
            f_namemax: struct.f_namemax
        };
    }

    @:hscriptVariable("statvfs_formatted")
    public static function getStatVfsFormatted(path:String):Null<{total:Int64, free:Int64, available:Int64, used:Int64}>
    {
        var stat = getStatVfs(path);
        if(stat == null)
            return null;

        var total:Int64 = stat.f_blocks * stat.f_frsize;
        var free:Int64  = stat.f_bfree * stat.f_frsize;
        var available:Int64  = stat.f_bavail * stat.f_frsize;
        var used:Int64  = total - free;

        return {
            total: total,
            free: free,
            available: available,
            used: used
        }
    }
}


typedef StatVFSTypedef = {
    var f_bavail:Int64;
    var f_bfree:Int64;
    var f_blocks:Int64;
    var f_favail:Int64;
    var f_ffree:Int64;
    var f_files:Int64;
    var f_bsize:Int64;
    var f_flag:Int64;
    var f_frsize:Int64;
    var f_fsid:Int64;
    var f_namemax:Int64;
}
#end