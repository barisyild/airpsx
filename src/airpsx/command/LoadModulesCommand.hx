package airpsx.command;
#if orbis
import cpp.extern.ExternLibKernel.sceKernelLoadStartModule;
import hx.well.console.AbstractCommand;
import cpp.lib.LibKernelSys;

class LoadModulesCommand extends AbstractCommand<Bool> {
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
        var modules = [
            '/system/common/lib/libSceSystemService.sprx',
            '/system/common/lib/libSceAppInstUtil.sprx',
            '/system/common/lib/libSceSysUtil.sprx',
            '/system/common/lib/libSceBgft.sprx',
            '/system/common/lib/libSceRemoteplay.sprx'
        ];

        for(module in modules)
        {
            var res:Int = sceKernelLoadStartModule(module, 0, null, 0, null, null);
            if(res < 0)
            {
                cpp.lib.LibKernel.sendNotificationRequest('Failed to load module from path: ${module}, res=${res}');
                return cast false;
            }
        }

        #if !prospero
        LibKernelSys.load();
        #end
        return cast true;
    }
}
#end