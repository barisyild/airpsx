package cpp.extern;

#if orbis
import cpp.Int32;
import cpp.ConstCharStar;

@:keep
@:include('stdlib.h')
extern class ExternStdlib {
    @:native('system')
    public static function system(title:ConstCharStar):Int32;
} //Empty
#end