package airpsx.command;

import hx.well.console.AbstractCommand;
import airpsx.pkg.PackageVo;
import sys.FileSystem;

class KillServePackageCommand extends AbstractCommand<Bool> {
    public override function group():String {
        return "package";
    }

    public function signature():String {
        return "kill-serve";
    }

    public function description():String {
        return "Serve package";
    }

    public function handle():Bool {
        var acquired = ServePackageCommand.packageMutex.tryAcquire();
        if(!acquired)
            return cast false;

        try {
            var packageVo:PackageVo = ServePackageCommand.packageVo;
            if(packageVo != null && packageVo.lastAccessTime < Sys.time() - 10) {
                killPackage(packageVo);
            }
        } catch (e) {
            ServePackageCommand.packageMutex.release();
            throw e;
        }
        ServePackageCommand.packageMutex.release();

        return cast true;
    }

    private function killPackage(packageVo:PackageVo):Void {
        trace("Killing package", packageVo.sessionKey);
        ServePackageCommand.packageVo = null;
        packageVo.dispose();
    }
}
