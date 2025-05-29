package airpsx.utils;
import airpsx.type.ScriptType;
class ResolveScript {
    public static function resolveUrl(key:String, type:ScriptType) {
        return 'https://airpsx.com/scripts/${resolveName(key, type)}';
    }

    public static function resolveName(key:String, type:ScriptType) {
        return switch (type) {
            case ScriptType.RULESCRIPT:
                '${key}.hx';
            case ScriptType.LUA:
                '${key}.lua';
            default:
                throw 'Unknown script type: ${type}';
        }
    }
}