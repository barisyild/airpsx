package cpp.lib;
#if orbis
import cpp.extern.ExternLibSceNet;
import cpp.extern.ExternLibSceNetCtl.SceNetCtlInfoExtern;
import cpp.extern.ExternLibSceNetCtl;
class LibSceNetCtl {
    public static function initialize():Bool {
        return ExternLibSceNet.sceNetInit() == 0;
    }

    public static function terminate():Bool {
        return ExternLibSceNet.sceNetTerm() == 0;
    }

    public static function ctlGetInfo():Null<SceNetCtlInfo> {
        ExternLibSceNetCtl.sceNetCtlInit();
        var info:SceNetCtlInfoExtern = SceNetCtlInfoExtern.create();
        if(ExternLibSceNetCtl.sceNetCtlGetInfo(14, info) < 0)
        {
            ExternLibSceNetCtl.sceNetCtlTerm();
            return null;
        }

        ExternLibSceNetCtl.sceNetCtlTerm();
        return info.toObject();
    }

    public static function getIpAddress():Null<String> {
        var ctlInfo = ctlGetInfo();
        if(ctlInfo == null)
            return null;

        return ctlInfo.ip_address;
    }
}
#end