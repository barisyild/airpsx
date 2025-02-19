package airpsx.hscript;

@:keep
class HScriptData {
    public static var variables:Map<String, Any>;

    public static function init():Void
    {
        variables = Reflect.field(Type.resolveClass("hscript.HScriptDataGenerated"), "variables");
    }
}