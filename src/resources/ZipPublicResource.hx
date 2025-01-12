package resources;
import haxe.io.Bytes;
import haxe.crypto.Base64;

@:build(macro.ZipResourceMacro.build("public", {bytesField:"bytes", hashField:"hash"}))
class ZipPublicResource {
    public static var bytes(default, null):String;
    public static var hash(default, null):String;
    private static var isFreed:Bool = false;

    public static function toBytes():Bytes
    {
        if(isFreed)
            throw "ZipPublicResource is already freed";

        return Base64.decode(bytes);
    }

    public static function free():Void
    {
        hash = "";
        bytes = "";
        isFreed = true;
    }
}