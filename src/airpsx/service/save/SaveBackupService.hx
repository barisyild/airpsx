package airpsx.service.save;

#if orbis
import sys.net.Socket;
import haxe.tar.StreamTarFile;
import utils.FileUtils;
import haxe.tar.TarCompress;
import haxe.Int64;
import sys.io.FileInput;
import sys.FileStat;
import sys.io.File;
import sys.FileSystem;
import haxe.tar.TarEntry;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;
import hx.well.http.RequestStatic.socket;

// This service serves save backups
class SaveBackupService extends AbstractService {
    public function new()
    {
        super();
    }

    public function execute(request:Request):AbstractResponse {
        var path:String = Config.USER_HOME_PATH;
        var profileId:String = request.route("profileId");

        var profileIds:Array<String>;
        if(profileId == null)
        {
            profileIds = FileSystem.readDirectory(path);
        }else{
            profileIds = [profileId];
        }

        var userSavePaths:Array<String> = [];
        for(profileId in profileIds)
        {
            userSavePaths.push('${Config.USER_HOME_PATH}/${profileId}/savedata');
            userSavePaths.push('${Config.USER_HOME_PATH}/${profileId}/savedata_meta');
            userSavePaths.push('${Config.USER_HOME_PATH}/${profileId}/savedata_prospero');
            userSavePaths.push('${Config.USER_HOME_PATH}/${profileId}/savedata_prospero_meta');
        }

        // Remove non-available folders
        userSavePaths = userSavePaths.filter(userSavePath -> FileSystem.exists(userSavePath));

        var files:Array<String> = FileUtils.getRecursiveFiles(...userSavePaths);
        var tarFileSize:Int64 = TarCompress.getTarFileSize(files, path);

        var fileName:String = 'ps5_savebackup_${Date.now().toString()}';
        var socket:Socket = socket();
        socket.output.writeString("HTTP/1.1 200 OK\r\n");
        socket.output.writeString('Content-Length: ${tarFileSize}\r\n');
        socket.output.writeString('Content-Disposition: attachment; filename=\"${fileName}.tar\"\r\n');
        socket.output.writeString("\r\n");


        var streamTarFile:StreamTarFile = new StreamTarFile();
        streamTarFile.write(socket.output, () -> {
            var file = files.shift();
            if(file == null)
                return null;

            var input:FileInput = null;
            var length:Int64 = 0;

            var isDirectory:Bool = file.endsWith("/");
            if(!isDirectory)
            {
                input = File.read(file, true);
                var stats:FileStat = FileSystem.stat(file);
                length = stats.size;
            }

            var entry = new TarEntry();
            entry.name = file.substr(path.length + 1);
            entry.length = length;
            entry.input = input;
            entry.isDirectory = isDirectory;
            return entry;
        });

        return null;
    }
}
#end