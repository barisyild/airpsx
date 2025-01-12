package utils;
import haxe.io.Bytes;
class StringUtils {
    public static function allocate(size:Int):String {
        return Bytes.alloc(size).toString();
    }

    public static function findCommonPrefix(paths:Array<String>) {
        if (paths == null || paths.length == 0) {
            return "";
        }

        // İlk path'ı temel alarak karşılaştırma başlat
        var firstPath:String = paths[0];
        var firstParts:Array<String> = firstPath.split("/");

        // Ortak kısmı bulmak için döngü
        var commonPrefix:StringBuf = new StringBuf();
        for (i in 0...firstParts.length) {
            var part:String = firstParts[i];
            for (path in paths) {
                var pathParts:Array<String> = path.split("/");
                if (i >= pathParts.length || pathParts[i] != part) {
                    return commonPrefix.toString();
                }
            }
            // Ortak kısmı ekle
            commonPrefix.add("/");
            commonPrefix.add(part);
        }

        return commonPrefix.toString();
    }
}
