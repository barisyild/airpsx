package airpsx.script;
import haxe.io.Output;
import haxe.io.NullOutput;
import airpsx.hscript.HScriptData;
abstract class ScriptBackend {
    public var output:Output = new NullOutput();
    public var extra(default, set):Map<String, Any> = new Map();

    public function set_extra(value:Map<String, Any>):Map<String, Any> {
        if(value == null)
            return extra;

        extra = value;
        buildExtra();
        return value;
    }

    public function new() {
        buildExtra();
    }

    private function buildExtra():Void {
        extra.set("GCCompact", () -> cpp.vm.Gc.compact());
        extra.set("GCMemUsage", () -> cpp.vm.Gc.memUsage());
        extra.set("GCRun", (major) -> cpp.vm.Gc.run(major));
        extra.set("GCMemAll", () -> {
            return {
                MEM_INFO_RESERVED: cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_RESERVED),
                MEM_INFO_CURRENT: cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_CURRENT),
                MEM_INFO_LARGE: cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_LARGE),
                MEM_INFO_USAGE: cpp.vm.Gc.memInfo(cpp.vm.Gc.MEM_INFO_USAGE),
            }
        });
        var hScriptDataKeys:Array<String> = [];
        for(key in HScriptData.variables.keys())
        {
            extra.set(key, HScriptData.variables.get(key));
            hScriptDataKeys.push(key);
        }

        extra.set("help", () -> [for(key in extra.keys()) key].join("\n"));
        extra.set("write", Reflect.makeVarArgs((args:Array<Dynamic>) -> output.writeString(args.join(" "))));
        extra.set("writeln", Reflect.makeVarArgs((args:Array<Dynamic>) -> output.writeString(args.join(" ") + "\n")));
        extra.set("print", Reflect.makeVarArgs((args:Array<Dynamic>) -> output.writeString(args.join(" ") + "\n")));
    }

    public abstract function execute(script:String):Dynamic;
}
