package hx.well.handler.media;
import hx.well.http.AbstractResponse;
import hx.well.http.Request;
import hx.well.handler.AbstractHandler;
import hx.well.validator.ValidatorRule;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import haxe.Exception;
import haxe.Int64;
using StringTools;
using StringTools;
import airpsx.utils.MP4Utils;

class MediaListHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var titleIDCache:Map<String, String> = new Map();

        var entries = [];
        var mediaExtensions = ["jxr", "png", "jpg", "jpeg", "mp4"];
        var files = [];
        recursiveScan("/user/av_contents", files);

        while (files.length > 0) {
            var file:String = files.shift();

            var filePath:String = null;
            var fileExtension:String = null;
            for(extension in mediaExtensions) {
                if(FileSystem.exists('${file}.${extension}')) {
                    filePath = '${file.replace("/user/av_contents", "")}.${extension}';
                    fileExtension = extension;
                    break;
                }
            }
            if(filePath == null)
                continue;

            var entry:Dynamic = {filePath: filePath};
            #if prospero
            entry.meta = Json.parse(File.getContent('${file}.meta'));
            #else
            // TODO: implement proper meta creation for videos
            entry.meta = {};

            try {
                var fileStats = FileSystem.stat('${file}.dat');
                var startTime = Int64.fromFloat(fileStats.ctime.getTime()); // convert to seconds
                var duration:Int = 0;
                if(fileExtension == "mp4") {
                    duration = Std.int(MP4Utils.getDuration('${file}.mp4')) * 1000;
                }

                entry.meta.segmentInfo = {
                    start: startTime,
                    mediaTime: [[0, duration]]
                };

                var titleID = file.split("/")[file.split("/").length - 3]; // CUSA52342
                if (~/[A-Z]{4}[0-9]{5}/.match(titleID)) {
                    entry.meta.appVerTitleId = titleID;
                }
            } catch (e:Exception) {
                // Handle exception if needed
            }
            #end
            entry.ext = null;

            var titleID:String = entry.meta.appVerTitleId;
            if(titleID != null) {
                if(!titleIDCache.exists(titleID))
                {
                    try
                    {
                        #if prospero
                        var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT titleName FROM tbl_contentinfo WHERE titleId = ?', titleID);
                        #else
                        var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT val as titleName FROM tbl_appinfo WHERE titleId = ? AND key = "TITLE"', titleID);
                        #end
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

            #if prospero
            if(file.endsWith(".meta"))
                out.push(path + "/" + file.replace(".meta", ""));
            #else
            if(file.endsWith(".dat"))
                out.push(path + "/" + file.replace(".dat", ""));
            #end
        }
    }
}