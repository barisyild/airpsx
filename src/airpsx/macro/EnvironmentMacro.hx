package airpsx.macro;
import haxe.macro.Expr;
class EnvironmentMacro {
    public static macro function get(key:String, ?defaultValue:String):Expr {
        var value:String = Sys.getEnv(key) ?? defaultValue;
        return macro $v{value};
    }
}