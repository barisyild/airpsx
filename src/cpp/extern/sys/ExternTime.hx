package cpp.extern.sys;
import cpp.Int32;
import cpp.Int64;
import cpp.Struct;
import cpp.Pointer;
import cpp.SizeT;
import cpp.TimeT;
import cpp.SusecondsT;
import cpp.AbstractPointer;

@:keep
@:include('sys/time.h')
extern class ExternTime {
    @:native('gettimeofday')
    public static function gettimeofday(tp:AbstractPointer<TimeValStruct>, ?tzp:AbstractPointer<TimeZoneStruct>) : Int32;

    @:native('settimeofday')
    public static function settimeofday(tp:AbstractPointer<TimeValStruct>, ?tzp:AbstractPointer<TimeZoneStruct>) : Int32;
}

@:keep
@:include('sys/time.h')
@:native('timeval')
@:structAccess
@:unreflective
extern class TimeValStruct {
    public static inline function create(): TimeValStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(TimeValStruct);
    }

    public var tv_sec:TimeT;
    public var tv_usec:SusecondsT;
}

@:keep
@:include('sys/time.h')
@:native('timezone')
@:structAccess
@:unreflective
extern class TimeZoneStruct {
    public static inline function create(): TimeZoneStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(TimeZoneStruct);
    }

    public var tz_minuteswest:Int32;
    public var tz_dsttime:Int32;
}
