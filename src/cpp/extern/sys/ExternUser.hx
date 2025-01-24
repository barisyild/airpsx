package cpp.extern.sys;
import cpp.PidT;
import cpp.ConstCharStar;
import cpp.Int32;
import cpp.SegszT;
import cpp.SizeT;
import cpp.extern.sys.ExternTime;
import cpp.UInt32;

@:keep
@:include('sys/user.h')
extern class ExternUser {

}

@:keep
@:include('sys/user.h')
@:native('kinfo_proc')
@:structAccess
@:unreflective
extern class KInfoProcStruct {
    @:native('ki_pid')
    public var pid:PidT;

    @:native('ki_ppid')
    public var ppid:PidT;

    @:native('ki_pgid')
    public var pgid:PidT;

    @:native('ki_sid')
    public var sid:PidT;

    @:native('ki_emul')
    public var emul:ConstCharStar;

    @:native('ki_stat')
    public var stat:ConstCharStar;

    @:native('ki_comm')
    public var comm:ConstCharStar;

    @:native('ki_structsize')
    public var structSize:Int32;

    @:native('ki_rssize')
    public var rssize:SegszT;

    @:native('ki_start')
    public var ki_start:TimeValStruct;

    public static inline function size():SizeT {
        return cpp.Native.sizeof(KInfoProcStruct);
    }
}

typedef KInfoProcTypedef = {
    pid:PidT,
    ppid:PidT,
    pgid:PidT,
    sid:PidT,
    emul:String,
    stat:String,
    comm:String,
    structSize:Int32,
    rssize:Null<Int>,
    start:Float,
    pageSize:Null<Int>,
    categoryType:Int32,
        //authID:Null<Int64>,
    titleID:String,
    appID:UInt32,
    appType:UInt32,
    //unknown1:UInt64,
    //unknown2:String
}