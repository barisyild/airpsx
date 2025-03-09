package airpsx.service.media;
import hx.well.http.AbstractResponse;
import hx.well.http.Request;
import hx.well.service.AbstractService;
import hx.well.validator.ValidatorRule;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
using StringTools;
using StringTools;

class MediaListService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var titleIDCache:Map<String, String> = new Map();

        var entries = [];
        var mediaExtensions = ["jxr", "png", "jpg", "jpeg", "mp4"];
        var files = [];
        recursiveScan("/user/av_contents", files);

        while (files.length > 0) {
            var file:String = files.shift();

            var filePath:String = null;
            for(extension in mediaExtensions) {
                if(FileSystem.exists('${file}.${extension}')) {
                    filePath = '${file.replace("/user/av_contents", "")}.${extension}';
                    break;
                }
            }
            if(filePath == null)
                continue;

            var entry:Dynamic = {filePath: filePath};
            entry.meta = Json.parse(File.getContent('${file}.meta'));
            entry.ext = null;

            var titleID:String = entry.meta.appVerTitleId;
            if(titleID != null) {
                if(!titleIDCache.exists(titleID))
                {
                    try
                    {
                        var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT titleName FROM tbl_contentinfo WHERE titleId = ?', titleID);
                        var titleName:String = resultSet.hasNext() ? resultSet.getResult(0) : null;
                        titleIDCache.set(titleID, titleName);
                    } catch (e)
                    {
                        titleIDCache.set(titleID, null);
                    }
                }
            }

            if(FileSystem.exists('${file}.ext'))
                entry.ext = Json.parse(File.getContent('${file}.ext'));

            entries.push(entry);
        }

        return {entries: entries, titles: titleIDCache};
    }

    private function recursiveScan(path:String, out:Array<String>):Void {
        // /user/av_contents/video/NPXS40087/CUSA04555/2f2/20231030_042141_00470308.mp4
        for(file in FileSystem.readDirectory(path)) {
            if(FileSystem.isDirectory(path + "/" + file))
                recursiveScan(path + "/" + file, out);

            if(file.endsWith(".meta"))
                out.push(path + "/" + file.replace(".meta", ""));
        }
    }
}
