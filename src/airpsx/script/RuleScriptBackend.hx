package airpsx.script;

import airpsx.hscript.HScriptData;
import rulescript.RuleScriptInterp;
import airpsx.hscript.HScriptData;
import haxe.io.Output;
import haxe.Log;
import rulescript.HxParser;
import hscript.Expr.Error;
import haxe.Exception;
import rulescript.RuleScript;
import hscript.Expr;
import airpsx.utils.RuleScriptUtils;

class RuleScriptBackend extends ScriptBackend {
    public function execute(script:String):Dynamic {
        var interp = new RuleScriptInterp();

        for(key in extra.keys())
        {
            interp.variables.set(key, extra.get(key));
        }

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
            var parserData = RuleScriptUtils.parse(script);
            var script = new RuleScript(interp, parserData.parser);
            var result = script.execute(parserData.expr);
            if(result != null) {
                trace(result);
                output.writeString('${result}\n');
            }

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
