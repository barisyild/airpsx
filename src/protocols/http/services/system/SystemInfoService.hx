package protocols.http.services.system;

#if orbis
import lib.LibKernel;
import lib.Systemctl;
import sys.net.Socket;
import protocols.http.HTTPRequest;

// This service returns non-variable system resources.
class SystemInfoService extends AbstractHttpService {
    public function new()
    {
        super();
    }

    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        return {
            modelName: LibKernel.getHwModelName(),
            serialNumber: #if release LibKernel.getHwSerialNumber() #else "CENSORED" #end,
            hw_machine: Systemctl.hardwareMachine,
            hw_model: Systemctl.hardwareModel,
            ostype: Systemctl.kernelOsType,
            ps4_sdk_version: Systemctl.kernelPs4SdkVersion,
            sdk_version: Systemctl.kernelSdkVersion,
            upd_version: Systemctl.kernelUpdVersion,
            kernel_version: Systemctl.kernelVersion,
            kernel_boot_time: Systemctl.kernelBootTime,
        };
    }
}
#end