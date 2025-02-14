package tools;
#if cpp
import cpp.CastCharStar;
import haxe.io.Bytes;
import cpp.ConstCharStar;
#end

class StringTools {
    public static function truncateAtNull(value:String):String {
        var result:String = "";
        for (i in 0...value.length) {
            if (value.charCodeAt(i) == 0x00)
                break;
            result += value.charAt(i);
        }
        return result;
    }

    #if cpp
    public static inline function copyFrom(destination:CastCharStar, target:String):Void {
        untyped __cpp__("strcpy({0}, {1})", destination, target);
    }
    #end
}
