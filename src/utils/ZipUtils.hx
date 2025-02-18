package utils;
import haxe.zip.Entry;
import sys.io.File;
import sys.FileSystem;
import haxe.crypto.Crc32;
import haxe.io.Bytes;
import haxe.io.Path;
import sys.net.Socket;
import haxe.io.Output;
import haxe.Int64;
import haxe.Int32;
import haxe.io.BytesInput;
import sys.io.FileInput;
import haxe.io.Input;
import sys.FileStat;
import haxe.Exception;
import haxe.CallStack;
import haxe.ds.Vector;
import haxe.io.BytesData;
using StringTools;

class ZipUtils {
    // https://code.haxe.org/category/other/haxe-zip.html
    // recursive read a directory, add the file entries to the list
    public static function getEntries(dir:String, entries:List<Entry> = null, inDir:Null<String> = null, entryHandler:Entry->Void = null) {
        if (entries == null) entries = new List<haxe.zip.Entry>();
        if (inDir == null) inDir = dir;
        for(file in FileSystem.readDirectory(dir)) {
            var path = Path.join([dir, file]);
            if (FileSystem.isDirectory(path)) {
                getEntries(path, entries, inDir);
            } else {
                var bytes:Bytes = Bytes.ofData(File.getBytes(path).getData());
                var entry:Entry = {
                    fileName: path.replace(inDir, ""),
                    fileSize: -1,
                    fileTime: Date.now(),
                    compressed: false,
                    dataSize: FileSystem.stat(path).size,
                    data: bytes,
                    crc32: null
                };
                if(entryHandler != null)
                    entryHandler(entry);

                if(entry.fileSize == -1)
                    entry.fileSize = bytes.length;

                if(entry.crc32 == null)
                    entry.crc32 = Crc32.make(bytes);

                entries.push(entry);
            }
        }
        return entries;
    }

    private static function generateCrc32Table():Vector<Int> {
        var table:Vector<Int> = new Vector<Int>(0xFF);
        var polynomial:Int = 0xedb88320;  // CRC-32 polynomial

        // Calculating the table for each byte
        for (i in 0...256) {
            var crc:Int = i;
            var j:Int = 8;
            while (j > 0) {
                // Lowest bit control and bit shifting
                if ((crc & 1) != 0) {
                    crc = (crc >>> 1) ^ polynomial;  // Polynomial with XOR
                } else {
                    crc = crc >>> 1;  // Bit shift only
                }
                j--;
            }
            table.set(i, crc);  // We add it to our table
        }

        return table;
    }

    public static function writeZip(socket:Socket, files:Array<ZipStreamEntity>):Void
    {

    }
}

class ZipStreamEntity {
    public var input:Input;
    public var length:Int64;
    public var fileName:String;
    public var isDirectory:Bool;
    public var stat:FileStat;

    public function new(input:Input, length:Int64, fileName:String, isDirectory:Bool, stat:FileStat = null) {
        this.input = input;
        this.length = length;
        this.fileName = fileName;
        this.isDirectory = isDirectory;
        this.stat = stat;
    }
}