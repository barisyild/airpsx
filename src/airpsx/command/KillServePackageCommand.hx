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
        var packageVo:PackageVo = PackageVo.current;
        if(packageVo != null && !packageVo.check()) {
            killPackage(packageVo);
        }
        return cast true;
    }

    private function killPackage(packageVo:PackageVo):Void {
        trace("Killing package", packageVo.sessionKey);
        packageVo.dispose();
    }
}
