package command;
import lib.LibKernel;
import lib.LibSceUserService;
import lib.Systemctl;
import lib.LibSceSystemService;
using tools.ExecutorTools;

class InitializeCommand extends Command {
    public function new() {
        super();
    }

    public function execute():Void {
        #if orbis
        if(!LibSceUserService.initialize())
        {
            LibKernel.sendNotificationRequest('sceUserServiceInitialize failed');
            fail();
        }

        trace("sceUserServiceInitialize success");
        trace(Systemctl.readStringByName("net.inet.ifq.ifq_len"));
        trace("1");

        trace(LibSceUserService.getLoginUserIdList());

        LibSceSystemService.lncUtilLaunchApp("NPXS40093");

        #end
    }
}