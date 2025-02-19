package airpsx.utils;
import haxe.io.Bytes;
class StringUtils {
    public static function allocate(size:Int):String {
        return Bytes.alloc(size).toString();
    }

    public static function findCommonPrefix(paths:Array<String>):String {
        if (paths == null || paths.length == 0) {
            return "";
        }

        var firstPath = paths[0];
        var firstParts = firstPath.split("/");

        var commonParts = [];
        for (i in 0...firstParts.length) {
            var part = firstParts[i];
            for (path in paths) {
                var pathParts = path.split("/");
                if (i >= pathParts.length || pathParts[i] != part) {
                    return commonParts.join("/");
                }
            }
            commonParts.push(part);
        }

        return commonParts.join("/");
    }
}
