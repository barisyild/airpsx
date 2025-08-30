package hx.well.handler.filesystem;

#if orbis
import sys.net.Socket;
import cpp.lib.sys.LibStatVfs;
import sys.FileSystem;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import airpsx.Const;
using airpsx.tools.StringTools;

class StorageInfoHandler extends AbstractHandler {

    public function execute(request:Request):AbstractResponse {
        var data = [];

        for(directory in Const.storageDirectories.keys())
        {
            var storageDirectoryName = Const.storageDirectories.get(directory);
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