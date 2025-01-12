package utils;
import sys.FileSystem;
class FileSystemUtils {
    public static function deleteDirectoryRecursively(path:String) : Void
    {
        if (FileSystem.exists(path) && FileSystem.isDirectory(path))
        {
            var entries:Array<String> = FileSystem.readDirectory(path);
            for (entry in entries) {
                if (FileSystem.isDirectory(path + '/' + entry)) {
                    deleteDirectoryRecursively(path + '/' + entry);
                    FileSystem.deleteDirectory(path + '/' + entry);
                } else {
                    FileSystem.deleteFile(path + '/' + entry);
                }
            }
        }
    }
}
