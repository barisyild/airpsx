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

        // Start comparison based on first path
        var firstPath:String = paths[0];
        var firstParts:Array<String> = firstPath.split("/");

        // Loop to find common part
        var commonPrefix:StringBuf = new StringBuf();
        for (i in 0...firstParts.length) {
            var part:String = firstParts[i];
            for (path in paths) {
                var pathParts:Array<String> = path.split("/");
                if (i >= pathParts.length || pathParts[i] != part) {
                    return commonPrefix.toString();
                }
            }
            // Add common part
            commonPrefix.add("/");
            commonPrefix.add(part);
        }

        return commonPrefix.toString();
    }
}
