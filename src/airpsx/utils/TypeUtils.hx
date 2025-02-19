package airpsx.utils;
class TypeUtils {
    public static function parseBool(data:Dynamic):Bool {
        return data == true || data == "true" || data == 1 || data == "1";
    }
}
