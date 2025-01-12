package lib.sys;

#if orbis
import externs.sys.ExternMount.StatFsStruct;
import externs.sys.ExternMount;

class LibMount {

    @:hscriptVariable("statfs")
    public static function getStatFs(path:String):Null<StatFSTypedef>
    {
        var struct = StatFsStruct.create();
        if(ExternMount.statfs(path, struct) == -1)
            return null;

        return {
            f_fstypename: struct.f_fstypename,
        };
    }
}


typedef StatFSTypedef = {
    var f_fstypename:String;
}
#end