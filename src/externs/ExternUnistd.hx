package externs;

#if orbis
import cpp.PidT;
import cpp.Int32;
import cpp.ConstCharStar;

@:keep
@:include('unistd.h')
extern class ExternUnistd {
    @:native('getpid')
    public static function getpid():PidT;

    @:native('getpagesize')
    public static function getpagesize():Int32;

    @:native('setproctitle')
    public static function setproctitle(title:ConstCharStar):Void;
} //Empty
#end