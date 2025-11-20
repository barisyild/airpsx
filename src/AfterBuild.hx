package ;

import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
using StringTools;

class AfterBuild {
    static function main():Void {
        var exportDir = #if prospero "Export/prospero" #else "Export/orbis" #end;
        FileSystem.rename('${exportDir}/HxWell${#if debug "-debug" #else "" #end}', "airpsx.elf");

        var elfFile = File.read("airpsx.elf", true);

        var newElfFilePath:String = "websrv_template/airpsx.elf";
        var newElfFile:FileOutput = File.write(newElfFilePath, true);
        newElfFile.writeInput(elfFile);
        elfFile.close();
        newElfFile.close();
    }
}
