package haxe.tar;
import sys.net.Socket;
import utils.ZipUtils.ZipStreamEntity;
import sys.io.FileInput;
import haxe.io.Bytes;
import haxe.Int64;
import haxe.io.Input;
import haxe.io.Output;
import sys.FileStat;
import sys.FileSystem;
using tools.IntegerTools;
using tools.Integer64Tools;
using StringTools;

class TarCompress {
    public static inline var PADDING_SIZE:Int = 512;
    public static var PADDING_BYTES:Bytes = Bytes.alloc(PADDING_SIZE);

    private static function createLongLinkHeader(output:Output, longName:String):Void {
        var longLinkHeader = Bytes.alloc(PADDING_SIZE);
        var longLinkHeaderData = longLinkHeader.getData();

        // LongLink identifier
        var nameBytes = Bytes.ofString("././@LongLink");
        longLinkHeader.blit(0, nameBytes, 0, nameBytes.length);

        // File mode (8 bytes)
        var modeStr = "0000777\x00";
        var modeBytes = Bytes.ofString(modeStr);
        longLinkHeader.blit(100, modeBytes, 0, 8);

        // Other fields set to 0 or empty
        var zeroBytes = Bytes.ofString("0000000\x00");
        longLinkHeader.blit(108, zeroBytes, 0, 8); // Owner ID
        longLinkHeader.blit(116, zeroBytes, 0, 8); // Group ID

        // Size of the long name (including null terminator)
        var sizeStr = (longName.length + 1).toOctal().lpad("0", 11) + "\x00";
        var sizeBytes = Bytes.ofString(sizeStr);
        longLinkHeader.blit(124, sizeBytes, 0, 12);

        var mtimeStr = "00000000000\x00";
        var mtimeBytes = Bytes.ofString(mtimeStr);
        longLinkHeader.blit(136, mtimeBytes, 0, 12);

        // Checksum initially spaces
        var checksumSpaces = Bytes.ofString("        ");
        longLinkHeader.blit(148, checksumSpaces, 0, 8);

        // Type flag for long name
        longLinkHeader.set(156, "L".charCodeAt(0));

        // Calculate checksum
        var sum = 0;
        for (i in 0...512) {
            sum += haxe.io.Bytes.fastGet(longLinkHeaderData, i);
        }

        // Write checksum
        var checksumStr = sum.toOctal().lpad("0", 6) + "\x00 ";
        var checksumBytes = Bytes.ofString(checksumStr);
        longLinkHeader.blit(148, checksumBytes, 0, 8);

        output.write(longLinkHeader);

        // Write the long name
        var nameWithNull = Bytes.ofString(longName + "\x00");
        output.write(nameWithNull);

        // Add padding to align to 512 bytes
        var padding:Int = cast (512 - (nameWithNull.length % 512)) % 512;
        if (padding > 0) {
            output.write(PADDING_BYTES.sub(0, padding));
        }
    }

    public static function createTarHeader(output:Output, fileName:String, isDirectory:Bool, fileSize:Int64):Bytes {
        if (fileName.length > 100) {
            createLongLinkHeader(output, fileName);
            fileName = fileName.substr(0, 100); // Truncate to 100 chars for the actual header
        }

        var headerBytes = Bytes.alloc(PADDING_SIZE);

        // File name (100 bytes)
        var nameBytes = Bytes.ofString(fileName);
        headerBytes.blit(0, nameBytes, 0, Std.int(Math.min(100, nameBytes.length)));

        // File mode (8 bytes)
        var modeStr = "0000777\x00"; // This is a simple mode string (755 in octal)
        var modeBytes = Bytes.ofString(modeStr);
        headerBytes.blit(100, modeBytes, 0, 8);

        // Owner ID (8 bytes)
        var uidStr = "0000000\x00"; // UID of the owner, zero for now
        var uidBytes = Bytes.ofString(uidStr);
        headerBytes.blit(108, uidBytes, 0, 8);

        // Group ID (8 bytes)
        var gidStr = "0000000\x00"; // GID of the group, zero for now
        var gidBytes = Bytes.ofString(gidStr);
        headerBytes.blit(116, gidBytes, 0, 8);

        // File size (12 bytes, octal)
        var sizeStr = fileSize.toOctal().lpad("0", 11) + "\x00";
        var sizeBytes = Bytes.ofString(sizeStr);
        headerBytes.blit(124, sizeBytes, 0, 12);

        // Last modification time (12 bytes)
        var mtimeStr = "00000000000\x00"; // Set the modification time to zero
        var mtimeBytes = Bytes.ofString(mtimeStr);
        headerBytes.blit(136, mtimeBytes, 0, 12);

        // Checksum (8 bytes) initially spaces
        var checksumSpaces = Bytes.ofString("        ");
        headerBytes.blit(148, checksumSpaces, 0, 8);

        // File type (1 byte)
        if (isDirectory) {
            headerBytes.set(156, "5".charCodeAt(0)); // Directory type
        } else {
            headerBytes.set(156, "0".charCodeAt(0)); // Regular file type
        }

        // Calculate checksum (8 bytes)
        var sum = 0;
        for (i in 0...512) {
            sum += headerBytes.get(i);
        }

        // Write checksum (ensure it is 6 octal digits)
        var checksumStr = sum.toOctal().lpad("0", 6) + "\x00 ";
        var checksumBytes = Bytes.ofString(checksumStr);
        headerBytes.blit(148, checksumBytes, 0, 8);

        output.write(headerBytes);
        return headerBytes;
    }

    public static function writeFileContent(output:Output, input:Input, length:Int64):Void {
        // Write file content in chunks
        output.writeInput(input);

        // Add padding to align to 512 bytes
        var padding:Int = cast (512 - (length % 512)) % 512;
        if (padding > 0) {
            output.write(PADDING_BYTES.sub(0, padding));
        }
    }

    public static function getTarFileSize(files:Array<String>, basePath:String):Int64
    {
        var tarSize:Int64 = 0;

        for (file in files) {
            // createTarHeader
            var name:String = file.substring(basePath.length + 1);
            if (name.length > 100) {
                // createLongLinkHeader
                tarSize += PADDING_SIZE;
                var padding:Int = cast (512 - ((name.length + 1) % 512)) % 512;
                if (padding > 0)
                    tarSize += padding;
            }
            tarSize += PADDING_SIZE;

            // writeTarFile
            var isDirectory:Bool = file.endsWith("/");
            if(!isDirectory)
            {
                var stats:FileStat = FileSystem.stat(file);
                var length:Int64 = stats.size;
                tarSize += length;

                var padding:Int = cast (512 - (length % 512)) % 512;
                if (padding > 0)
                    tarSize += padding;
            }
        }

        tarSize += 1024;
        return tarSize;
    }

    /*public static function writeTarFile(output:Output, objects:Array<ZipStreamEntity>):Void {
        try {
            // First write all directories (empty files, with size 0)
            for (obj in objects) {
                if (obj.isDirectory) {
                    createTarHeader(output, obj.fileName, true, 0);
                }
            }

            // Then write all files
            for (obj in objects) {
                if (obj.isDirectory) continue;

                var input:Input = obj.input;
                createTarHeader(output, obj.fileName, false, obj.length);
                writeFileContent(output, input, obj.length);
                input.close();
            }

            // Add end marker (two empty 512-byte blocks)
            for (i in 0...2) {
                output.write(PADDING_BYTES);
            }
        } catch (e) {
            trace(e);
            closeAll(objects);
            throw e;
        }

        trace("end");
    }

    private static function closeAll(objects:Array<ZipStreamEntity>):Void {
        for (object in objects) {
            try {
                object.input.close();
            } catch (e) {
                // Ignore close errors
            }
        }
    }*/
}