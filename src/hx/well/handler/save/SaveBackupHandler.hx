package hx.well.handler.save;

#if orbis
import sys.net.Socket;
import haxe.tar.StreamTarFile;
import airpsx.utils.FileUtils;
import haxe.tar.TarCompress;
import haxe.Int64;
import sys.io.FileInput;
import sys.FileStat;
import sys.io.File;
import sys.FileSystem;
import haxe.tar.TarEntry;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;
import airpsx.Const;
import hx.well.http.ResponseBuilder;
import hx.well.http.encoding.DeflateEncodingOptions;

// This service serves save backups
class SaveBackupHandler extends AbstractHandler {
    public function new()
    {
        super();
    }

    public function execute(request:Request):AbstractResponse {
        var path:String = Const.USER_HOME_PATH;
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
            userSavePaths.push('${Const.USER_HOME_PATH}/${profileId}/savedata');
            userSavePaths.push('${Const.USER_HOME_PATH}/${profileId}/savedata_meta');
            userSavePaths.push('${Const.USER_HOME_PATH}/${profileId}/savedata_prospero');
            userSavePaths.push('${Const.USER_HOME_PATH}/${profileId}/savedata_prospero_meta');
        }

        // Remove non-available folders
        userSavePaths = userSavePaths.filter(userSavePath -> FileSystem.exists(userSavePath));

        var files:Array<String> = FileUtils.getRecursiveFiles(...userSavePaths);
        var tarFileSize:Int64 = TarCompress.getTarFileSize(files, path);

        var fileName:String = '${#if prospero "ps5" #else "ps4" #end}_savebackup_${Date.now().toString()}';


        var staticResponse = ResponseBuilder.asStatic();
        staticResponse.contentLength = tarFileSize;
        staticResponse.header("Content-Disposition", 'attachment; filename=\"${fileName}.tar\"');

        request.context.beginWrite();

        var streamTarFile:StreamTarFile = new StreamTarFile();
        streamTarFile.write(request.context.output, () -> {
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