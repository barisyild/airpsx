package hx.well.handler.system;

#if orbis
import cpp.lib.LibKernel;
import cpp.lib.Systemctl;
import sys.net.Socket;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import cpp.lib.LibKernelSys;

// This service returns non-variable system resources.
class SystemInfoHandler extends AbstractHandler {
    public function new()
    {
        super();
    }

    public function execute(request:Request):AbstractResponse {
        return {
            modelName: LibKernelSys.getHwModelName(),
            serialNumber: #if release LibKernelSys.getHwSerialNumber() #else "CENSORED" #end,
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