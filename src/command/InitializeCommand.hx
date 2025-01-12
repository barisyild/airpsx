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

        #end
    }
}