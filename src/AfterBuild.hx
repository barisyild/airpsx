package ;

import sys.io.File;
import haxe.io.BytesBuffer;
import sys.FileSystem;
using StringTools;

class AfterBuild {
    static function isValidVersion(version:String):Bool {
        return ~/^\d\.\d{2}$/.match(version);
    }

    static function isValidTid(tid:String):Bool {
        return ~/^[A-Za-z]{4}\d{5}$/.match(tid);
    }

    static function addHeaderToElf(elfFilename:String, tid:String, version:String):Void {
        if (!isValidVersion(version)) {
            trace("Error: Version must be in the format x.xx (e.g., 1.00)");
            return;
        }
        if (!isValidTid(tid)) {
            trace("Error: TID must be the first 4 letters followed by 5 numbers (e.g., ABCD12345)");
            return;
        }

        var headerPrefix = "etaHEN_PLUGIN";
        var header = headerPrefix + "\x00" + tid + "\x00" + version + "\x00";
        var newFilename = elfFilename.split(".elf")[0] + ".plugin";

        try {
            var elfContents = File.getBytes(elfFilename);
            var newFileBuffer = new BytesBuffer();
            newFileBuffer.addString(header);
            newFileBuffer.addBytes(elfContents, 0, elfContents.length);

            File.saveBytes(newFilename, newFileBuffer.getBytes());
            verifyHeader(newFilename, headerPrefix.length);

            var formattedHeader = header.split("\x00").join(" ").split(headerPrefix + " ").join("");
            trace("Header added to " + elfFilename + " and saved as " + newFilename + ".");
            trace("Plugin Info: " + formattedHeader);
        } catch (e:Dynamic) {
            trace("Error: " + e);
        }
    }

    static function verifyHeader(fileName:String, prefixLength:Int):Void {
        var file = File.getBytes(fileName);
        var header = file.sub(0, prefixLength).toString();
        if (header.startsWith("etaHEN_PLUGIN")) {
            trace("Verification: Header correctly added.");
        } else {
            trace("Verification: Header not found.");
        }
    }

    static function main():Void {
        FileSystem.rename("out/HxWell", "airpsx.elf");

        var elfFilename = "airpsx.elf";
        var tid = "AIRX00000";
        var version = Sys.getEnv("version") ?? "0.00";

        if (isValidVersion(version) && isValidTid(tid)) {
            addHeaderToElf(elfFilename, tid, version);
        } else {
            trace("Invalid TID or version format.");
        }
    }
}
