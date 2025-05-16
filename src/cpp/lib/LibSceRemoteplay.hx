package cpp.lib;

#if orbis
import cpp.Int32;
import cpp.extern.ExternLibSceRemoteplay;

class LibSceRemoteplay {
    @:hscriptVariable("sceRemoteplayInitialize")
    public static function initialize():Bool {
        return ExternLibSceRemoteplay.sceRemoteplayInitialize(0, 0) == 0;
    }

    @:hscriptVariable("sceRemoteplayGeneratePinCode")
    public static function generatePinCode():Int32 {
        var pinCode:UInt32 = -1;
        ExternLibSceRemoteplay.sceRemoteplayGeneratePinCode(pinCode);
        return pinCode;
    }

    @:hscriptVariable("sceRemoteplayConfirmDeviceRegist")
    public static function confirmDeviceRegist():Null<{result:Int32, pair_stat:Int32, pair_err:Int32}> {
        var pair_stat:Int32 = -1;
        var pair_err:Int32 = -1;
        var result = ExternLibSceRemoteplay.sceRemoteplayConfirmDeviceRegist(pair_stat, pair_err);
        if(result != 0) return null;

        return {result: result, pair_stat: pair_stat, pair_err: pair_err};
    }

    @:hscriptVariable("sceRemoteplayNotifyPinCodeError")
    public static function notifyPinCodeError(errorCode:Int32):Int32 {
        return ExternLibSceRemoteplay.sceRemoteplayNotifyPinCodeError(errorCode);
    }
}
#end