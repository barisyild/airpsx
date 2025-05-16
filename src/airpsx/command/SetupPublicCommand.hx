package airpsx.command;
import haxe.io.Bytes;
import airpsx.resources.ZipPublicResource;
import sys.FileSystem;
import sys.io.File;
import airpsx.utils.FileSystemUtils;
import airpsx.utils.ExtractZipUtils;
import airpsx.Config;
import hx.well.console.AbstractCommand;
class SetupPublicCommand extends AbstractCommand {
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
        if(!FileSystem.exists(Config.DATA_PATH))
            FileSystem.createDirectory(Config.DATA_PATH);

        if(!FileSystem.exists(Config.SCRIPT_PATH))
            FileSystem.createDirectory(Config.SCRIPT_PATH);

        // Cleanup temp directory
        FileSystemUtils.deleteDirectoryRecursively(Config.TEMP_PATH);

        if(!FileSystem.exists(Config.TEMP_PATH))
            FileSystem.createDirectory(Config.TEMP_PATH);

        if(checkUpdateAvailable())
        {
            FileSystemUtils.deleteDirectoryRecursively('${Config.DATA_PATH}/public');
            FileSystem.createDirectory('${Config.DATA_PATH}/public');

            var bytes:Bytes = ZipPublicResource.toBytes();
            ExtractZipUtils.extractZip(bytes, '${Config.DATA_PATH}/public');
            File.saveContent('${Config.DATA_PATH}/public.version.txt', ZipPublicResource.hash);
        }else{
            trace("No update available");
        }
        ZipPublicResource.free();
        #if cpp
        cpp.vm.Gc.compact();
        #end
        return cast true;
    }

    private function checkUpdateAvailable():Bool
    {
        var versionFilePath:String = '${Config.DATA_PATH}/public.version.txt';
        if(!FileSystem.exists(versionFilePath))
            return true;

        var versionFileContent:String = sys.io.File.getContent(versionFilePath);
        return versionFileContent != ZipPublicResource.hash;
    }
}
