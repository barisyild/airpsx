package command;
import haxe.io.Bytes;
import resources.ZipPublicResource;
import sys.FileSystem;
import sys.io.File;
import utils.FileSystemUtils;
import utils.ExtractZipUtils;
import haxe.crypto.Base64;
class SetupPublicCommand extends Command {
    public function new() {
        super();
    }

    public function execute():Void {
        if(!FileSystem.exists(Config.DATA_PATH))
            FileSystem.createDirectory(Config.DATA_PATH);

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
        cpp.vm.Gc.compact();
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
