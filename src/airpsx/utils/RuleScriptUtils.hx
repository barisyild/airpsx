package airpsx.utils;
import rulescript.RuleScriptInterp;
import airpsx.hscript.HScriptData;
import haxe.io.Output;
import haxe.Log;
import rulescript.HxParser;
import hscript.Expr.Error;
import haxe.Exception;
import rulescript.RuleScript;
import hscript.Expr;
class RuleScriptUtils {
    public static function parse(code:String):{parser:HxParser, expr:Expr} {
        var parser:HxParser = new HxParser();
        parser.allowAll();
        var expr:Expr = parser.parse(code);
        return {parser: parser, expr: expr};
    }

    public static function execute(code:String, output:Output, ?extra:Map<String, Any>):Dynamic {
        var interp = new RuleScriptInterp();
        interp.variables.set("Math", Math);
        interp.variables.set("Date", Date);
        interp.variables.set("Sys", Sys);
        interp.variables.set("FileSystem", sys.FileSystem);
        interp.variables.set("File", sys.io.File);
        interp.variables.set("GCCompact", () -> cpp.vm.Gc.compact());
        interp.variables.set("GCMemUsage", () -> cpp.vm.Gc.memUsage());
        interp.variables.set("GCRun", (major) -> cpp.vm.Gc.run(major));
        interp.variables.set("GCMemAll", () -> {
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
            interp.variables.set(key, HScriptData.variables.get(key));
            hScriptDataKeys.push(key);
        }

        if(extra != null)
        {
            for(key in extra.keys())
            {
                interp.variables.set(key, extra.get(key));
                hScriptDataKeys.push(key);
            }
        }

        interp.variables.set("help", () -> hScriptDataKeys.join("\n"));
        interp.variables.set("write", Reflect.makeVarArgs((args:Array<Dynamic>) -> output.writeString(args.join(" "))));
        interp.variables.set("writeln", Reflect.makeVarArgs((args:Array<Dynamic>) -> output.writeString(args.join(" ") + "\n")));

        // Custom Trace
        interp.variables.set("trace", Reflect.makeVarArgs(el -> {
            var inf = interp.posInfos();
            var v:Null<Dynamic> = el.shift();
            if(el.length > 0)
                inf.customParams = el;

            var message = Log.formatOutput(v, inf);
            haxe.Log.trace(message);
            output.writeString('${message}\n');
        }));

        try
        {
            var parserData = parse(code);
            var script = new RuleScript(interp, parserData.parser);
            var result = script.execute(parserData.expr);
            trace(result);
            output.writeString('${result}\n');
            return result;
        } catch (e:Error) {
            trace(e);
            output.writeString('${e}\n');
            return null;
        } catch (e:Exception) {
            trace(e, e.stack);
            output.writeString('${e} ${e.stack.toString()}\n');
            return null;
        } catch (e:Dynamic) {
            trace("Dynamic");
            output.writeString('Dynamic - ${e}\n');
            return null;
        }
    }
}
