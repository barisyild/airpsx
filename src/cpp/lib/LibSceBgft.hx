package cpp.lib;
#if !prospero
import cpp.extern.ExternLibSceBgft.BgftInitParams;
import cpp.extern.ExternLibSceBgft;
class LibSceBgft {
    private static var mem:Star<cpp.Void> = null;

    public static function initialize():Bool {
        var bgftInitParams:BgftInitParams = BgftInitParams.create();
        bgftInitParams.size = 0x100000;
        mem = bgftInitParams.mem = untyped __cpp__('calloc(1, {0})', bgftInitParams.size); //cpp.Native.calloc(1, bgftInitParams.size);

        if (bgftInitParams.mem == null) {
            LibKernel.sendNotificationRequest("no memory");
            trace("no memory");
            return false;
        }

        return ExternLibSceBgft.sceBgftServiceIntInit(bgftInitParams) == 0;
    }

    public static function terminate():Bool {
        if (mem != null) {
            var result:Bool = ExternLibSceBgft.sceBgftServiceIntTerm() == 0;
            if(result)
            {
                cpp.Native.free(mem);
                mem = null;
            }else{
                LibKernel.sendNotificationRequest("sceBgftServiceIntTerm failed");
            }
            return result;
        }

        return false;
    }
}
#end
