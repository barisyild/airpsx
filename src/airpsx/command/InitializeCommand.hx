package airpsx.command;
import cpp.lib.LibKernel;
import cpp.lib.LibSceUserService;
import hx.well.console.AbstractCommand;
import cpp.lib.LibSceAppInstUtil;
import cpp.lib.LibSceRemoteplay;
import cpp.lib.LibSceBgft;

class InitializeCommand extends AbstractCommand<Bool> {
    public function new() {
        super();
    }

    public function signature():String {
        return null;
    }

    public function description():String {
        return null;
    }

    public function handle():Bool {
        #if orbis
        if(!LibSceUserService.initialize())
        {
            LibKernel.sendNotificationRequest('sceUserServiceInitialize failed');
            return cast false;
        }

        if(!LibSceAppInstUtil.initialize())
        {
            LibKernel.sendNotificationRequest('sceLibSceAppInstUtil failed');
        }

        if(!LibSceRemoteplay.initialize())
        {
            LibKernel.sendNotificationRequest('sceLibSceRemoteplay failed');
        }

        #if !prospero
        if(!LibSceBgft.initialize())
        {
            LibKernel.sendNotificationRequest('sceLibSceBgft failed');
        }
        #end
        #end
        return cast true;
    }
}