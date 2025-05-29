package airpsx.script;
import haxe.CallStack;
import haxe.Exception;

class LuaScriptBackend extends ScriptBackend {
    public function execute(script:String):Dynamic {
        var result:Dynamic = null;

        var lua = new vm.lua.Lua();

        try {
            var extraBlackList:Array<String> = ["sceRegMgrSetInt64"];

            for(key in extra.keys())
            {
                if(extraBlackList.contains(key))
                    continue;

                lua.setGlobalVar(key, extra.get(key));
            }

            // Manually add the sceRegMgrSetInt64 function because Int64 loses type within the array, remove this when issue resolved https://github.com/HaxeFoundation/hxcpp/issues/1227
            lua.run("function sceRegMgrSetInt64(n, val)
                local bytes = {}
                for i = 0, 7 do
                    bytes[i + 1] = (val >> (i * 8)) & 0xFF
                end
                return sceRegMgrSetBin(n, bytes)
            end");
            lua.run(script);

            result = lua.call("main", []);
            if(result != null) {
                trace(result);
                output.writeString('${result}\n');
            }

            lua.destroy();
        } catch (e:Exception) {
            lua.destroy();
            output.writeString('${e.message}\n');
            output.writeString(CallStack.toString(e.stack));
        }

        return result;
    }
}
