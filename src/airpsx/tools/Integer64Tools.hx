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

    public static function toArray(n:Int64):Array<cpp.UInt8> {
        var array = new Array<cpp.UInt8>();

        // Low 32 bit (little-endian)
        var low = n.low;
        array.push(low & 0xFF);
        array.push((low >> 8) & 0xFF);
        array.push((low >> 16) & 0xFF);
        array.push((low >> 24) & 0xFF);

        // High 32 bit (little-endian)
        var high = n.high;
        array.push(high & 0xFF);
        array.push((high >> 8) & 0xFF);
        array.push((high >> 16) & 0xFF);
        array.push((high >> 24) & 0xFF);
        return array;
    }
}
