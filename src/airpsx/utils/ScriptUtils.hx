package airpsx.utils;
import haxe.io.Output;
import airpsx.type.ScriptType;
import airpsx.script.RuleScriptBackend;
import airpsx.script.ScriptBackend;
import airpsx.script.LuaScriptBackend;
class ScriptUtils {
    public static function execute(script:String, type:ScriptType, output:Output, ?extra:Map<String, Any>):Dynamic {
        var scriptBackend:ScriptBackend = switch (type) {
            case RULESCRIPT:
                new RuleScriptBackend();
            case LUA:
                new LuaScriptBackend();
        }

        scriptBackend.output = output;
        scriptBackend.extra = extra;
        return scriptBackend.execute(script);
    }
}
