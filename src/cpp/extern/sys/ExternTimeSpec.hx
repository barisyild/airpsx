package cpp.extern.sys;
import cpp.SizeT;
import cpp.TimeT;

@:keep
@:include('sys/timespec.h')
@:native('timespec')
@:structAccess
@:unreflective
extern class TimeSpecStruct {
    public static inline function create(): TimeSpecStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(TimeSpecStruct);
    }

    public var tv_sec:TimeT;
    public var tv_nsec:Int64;
}