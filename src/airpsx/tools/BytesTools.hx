package airpsx.tools;

#if cpp
import cpp.Pointer;
import haxe.io.Bytes;
import cpp.RawPointer;
class BytesTools {
    public static function toPointer(bytes:Bytes):Pointer<cpp.UInt8> {
        return Pointer.arrayElem(bytes.getData(), 0);
    }

    public static function toRawPointer(bytes:Bytes):RawPointer<cpp.UInt8> {
        return toPointer(bytes).raw;
    }
}
#end