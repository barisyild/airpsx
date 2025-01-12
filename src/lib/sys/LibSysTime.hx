package lib.sys;

#if orbis
import externs.sys.ExternTime.TimeValStruct;
import externs.sys.ExternTime;

class LibSysTime {
    public static function getTime():{seconds:Float, microseconds:Float}
    {
        var timeValStruct = TimeValStruct.create();
        ExternTime.gettimeofday(timeValStruct);
        return {seconds: timeValStruct.tv_sec, microseconds: timeValStruct.tv_usec};
    }

    public static function setTime(seconds:Float, microseconds:Float = 0):Bool
    {
        var timeValStruct = TimeValStruct.create();
        timeValStruct.tv_sec = cast seconds;
        timeValStruct.tv_usec = microseconds;
        return ExternTime.settimeofday(timeValStruct) == 0;
    }
}
#end