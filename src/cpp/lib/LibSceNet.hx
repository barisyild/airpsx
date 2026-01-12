package cpp.lib;
#if orbis
import cpp.extern.ExternLibSceNet;
class LibSceNet {
    public static function initialize():Bool {
        return ExternLibSceNet.sceNetInit() == 0;
    }

    public static function terminate():Bool {
        return ExternLibSceNet.sceNetTerm() == 0;
    }
}
#end