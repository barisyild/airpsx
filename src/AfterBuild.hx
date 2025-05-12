package ;

import sys.FileSystem;
using StringTools;

class AfterBuild {
    static function main():Void {
        FileSystem.rename("out/HxWell", "airpsx.elf");
    }
}
