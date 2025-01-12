package utils;
import sys.FileSystem;
import haxe.Int64;
import sys.FileStat;
import lib.sys.LibMount;
using StringTools;

class FileUtils {
    public static function getRecursiveFiles(...paths:String):Array<String> {
        var result:Array<String> = [];
        for(path in paths)
        {
            trace(path);
            if(FileSystem.isDirectory(path))
            {
                #if orbis
                var statFs = LibMount.getStatFs(path);
                if(statFs == null || statFs.f_fstypename == "devfs")
                    continue;
                #end

                var files:Array<String> = FileSystem.readDirectory(path);
                for (file in files) {
                    var filePath = path + "/" + file;
                    if (FileSystem.isDirectory(filePath)) {
                        result.push(filePath + "/");
                        result = result.concat(getRecursiveFiles(filePath));
                    } else {
                        result.push(filePath);
                    }
                }
            }else{
                result.push(path);
            }
        }
        return result;
    }

    public static function getTotalFileSizeFromPath(...path:String):Int64
    {
        var files:Array<String> = getRecursiveFiles(...path);
        return getTotalFileSizeFromArray(files);
    }

    public static function getTotalFileSizeFromArray(files:Array<String>):Int64
    {
        var totalFileSize:Int64 = 0;
        for (file in files) {
            var isDirectory:Bool = file.endsWith("/");
            if(!isDirectory)
            {
                var stats:FileStat = FileSystem.stat(file);
                totalFileSize += stats.size;
            }
        }
        return totalFileSize;
    }
}
