package ;

import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
using StringTools;

class AfterBuild {
    static function main():Void {
        FileSystem.rename("Export/cpp/out/HxWell", "airpsx.elf");

        var elfFile = File.read("airpsx.elf", true);

        var newElfFilePath:String = "websrv_template/airpsx.elf";
        var newElfFile:FileOutput = File.write(newElfFilePath, true);
        newElfFile.writeInput(elfFile);
        elfFile.close();
        newElfFile.close();
    }
}
