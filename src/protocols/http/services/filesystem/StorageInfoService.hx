package protocols.http.services.filesystem;

#if orbis
import sys.net.Socket;
import lib.sys.LibStatVfs;
import sys.FileSystem;
import protocols.http.HTTPRequest;
using tools.StringTools;

class StorageInfoService extends AbstractHttpService {

    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var data = [];

        for(directory in Config.storageDirectories.keys())
        {
            var storageDirectoryName = Config.storageDirectories.get(directory);
            if(FileSystem.stat(directory).dev < 0)
                continue;

            var statVfsData = LibStatVfs.getStatVfsFormatted(directory);
            data.push({
                name: storageDirectoryName,
                path: directory,
                total: statVfsData.total,
                free: statVfsData.free,
                available: statVfsData.available,
                used: statVfsData.used
            });
        }

        return data;
    }
}
#end