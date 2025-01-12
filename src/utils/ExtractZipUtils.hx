package utils;
import haxe.zip.Entry;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import sys.FileSystem;
import sys.io.File;
class ExtractZipUtils {
    public static function extractZip(bytes:Bytes, path:String):Void {
        var input = new BytesInput(bytes);
        var entries = haxe.zip.Reader.readZip(input);
        for(entry in entries) {
            var entryPath = path + "/" + entry.fileName;
            if(entry.fileName.charAt(entry.fileName.length - 1) == "/") {
                FileSystem.createDirectory(entryPath);
            } else {
                var directoryPath = entryPath.substring(0, entryPath.lastIndexOf("/"));
                if(!FileSystem.exists(directoryPath))
                {
                    FileSystem.createDirectory(directoryPath);
                }

                if(entry.compressed)
                {
                    entry.data = haxe.zip.Uncompress.run(entry.data);
                }

                var file = File.write(entryPath, true);
                file.write(entry.data);
                file.close();
            }
        }
    }
}
