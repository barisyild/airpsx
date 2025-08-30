package airpsx.command;
import haxe.io.Bytes;
import airpsx.resources.ZipPublicResource;
import sys.FileSystem;
import sys.io.File;
import airpsx.utils.FileSystemUtils;
import airpsx.utils.ExtractZipUtils;
import airpsx.Const;
import hx.well.console.AbstractCommand;
class SetupPublicCommand extends AbstractCommand<Bool> {
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
        if(!FileSystem.exists(Const.DATA_PATH))
            FileSystem.createDirectory(Const.DATA_PATH);

        if(!FileSystem.exists(Const.SCRIPT_PATH))
            FileSystem.createDirectory(Const.SCRIPT_PATH);

        // Cleanup temp directory
        FileSystemUtils.deleteDirectoryRecursively(Const.TEMP_PATH);

        if(!FileSystem.exists(Const.TEMP_PATH))
            FileSystem.createDirectory(Const.TEMP_PATH);

        if(checkUpdateAvailable())
        {
            FileSystemUtils.deleteDirectoryRecursively('${Const.DATA_PATH}/public');
            FileSystem.createDirectory('${Const.DATA_PATH}/public');

            var bytes:Bytes = ZipPublicResource.toBytes();
            ExtractZipUtils.extractZip(bytes, '${Const.DATA_PATH}/public');
            File.saveContent('${Const.DATA_PATH}/public.version.txt', ZipPublicResource.hash);
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
        var versionFilePath:String = '${Const.DATA_PATH}/public.version.txt';
        if(!FileSystem.exists(versionFilePath))
            return true;

        var versionFileContent:String = sys.io.File.getContent(versionFilePath);
        return versionFileContent != ZipPublicResource.hash;
    }
}
