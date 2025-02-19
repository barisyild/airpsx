package airpsx.tools;
import haxe.Int64;

class IntegerTools {
    public static function toOctal(n:Int):String {
        if (n == 0) return "0";
        var octal = "";
        var num = n;
        while (num > 0) {
            octal = (num % 8) + octal;
            num = Std.int(num / 8);
        }
        return octal;
    }
}
