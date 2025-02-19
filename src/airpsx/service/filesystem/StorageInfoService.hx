package airpsx.service.filesystem;

#if orbis
import sys.net.Socket;
import cpp.lib.sys.LibStatVfs;
import sys.FileSystem;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using tools.StringTools;

class StorageInfoService extends AbstractService {

    public function execute(request:Request):AbstractResponse {
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