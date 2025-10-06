package cpp.extern;


#if orbis
import cpp.AbstractArrayPointer;
import cpp.Int32;
import cpp.SizeT;

@:keep
@:include('libSceRemoteplay.h')
extern class ExternLibSceRemoteplay {
    @:native('sceRemoteplayInitialize')
    public static function sceRemoteplayInitialize(param:Int32, size:SizeT):Int32;

    @:native('sceRemoteplayGeneratePinCode')
    public static function sceRemoteplayGeneratePinCode(pinCode:AbstractPointer<UInt32>):Int32;

    @:native('sceRemoteplayConfirmDeviceRegist')
    public static function sceRemoteplayConfirmDeviceRegist(deviceId:AbstractPointer<Int32>, pinCode:AbstractPointer<Int32>):Int32;

    @:native('sceRemoteplayNotifyPinCodeError')
    public static function sceRemoteplayNotifyPinCodeError(errorCode:Int32):Int32;
}
#end