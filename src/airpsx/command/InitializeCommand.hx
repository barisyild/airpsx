package airpsx.command;
import cpp.lib.LibKernel;
import cpp.lib.LibSceUserService;
import cpp.lib.Systemctl;
import cpp.lib.LibSceSystemService;
import hx.well.console.AbstractCommand;
import cpp.lib.LibSceAppInstUtil;
import cpp.lib.LibSceRemoteplay;

class InitializeCommand extends AbstractCommand {
    public function new() {
        super();
    }

    public function signature():String {
        return null;
    }

    public function description():String {
        return null;
    }

    public function handle<T>():T {
        #if orbis
        if(!LibSceUserService.initialize())
        {
            LibKernel.sendNotificationRequest('sceUserServiceInitialize failed');
            return cast false;
        }

        trace("hello");
        if(!LibSceAppInstUtil.initialize())
        {
            LibKernel.sendNotificationRequest('sceLibSceAppInstUtil failed');
        }

        if(!LibSceRemoteplay.initialize())
        {
            LibKernel.sendNotificationRequest('sceLibSceRemoteplay failed');
        }

        #end
        return cast true;
    }
}