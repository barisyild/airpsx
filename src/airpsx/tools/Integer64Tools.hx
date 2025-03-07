package airpsx.tools;
import haxe.Int64;
class Integer64Tools {
    public static function toOctal(n:Int64):String {
        if (n == 0) return "0";
        var octal = "";
        var num = n;
        while (num > 0) {
            octal = (num % 8) + octal;
            num = num / 8;
        }
        return octal;
    }

    public static function ofUInt(n:Int):Int64 {
        var uintValue: UInt = cast (n & 0xFFFFFFFF);
        return Int64.make(0, uintValue);
    }
}
