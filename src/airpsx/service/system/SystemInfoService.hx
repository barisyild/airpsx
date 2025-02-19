package airpsx.service.system;

#if orbis
import cpp.lib.LibKernel;
import cpp.lib.Systemctl;
import sys.net.Socket;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;

// This service returns non-variable system resources.
class SystemInfoService extends AbstractService {
    public function new()
    {
        super();
    }

    public function execute(request:Request):AbstractResponse {
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