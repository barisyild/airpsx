package utils;
import haxe.io.Bytes;
import sys.net.Socket;
import utils.ZipUtils.ZipStreamEntity;
using StringTools;
class TarUtils {
    private static var NULL_CHAR = Bytes.alloc(1).toString();
    private static inline var BLOCK_SIZE = 512;
    private static inline var NAME_LENGTH = 100;
    private static inline var DEFAULT_MODE = "0000644 ";

    static public function createTar(socket:Socket, files:Array<ZipStreamEntity>):Void {
        // Write tar headers and data for each of the files
        for (file in files) {
            var header = createHeader(file.fileName, file.length);

            // Write header information
            socket.output.write(header);
            // Write file content
            socket.output.writeInput(file.input);
            file.input.close();

            // File length must be aligned in a 512 byte block
            var padding = BLOCK_SIZE - (file.length % BLOCK_SIZE);
            if (padding < BLOCK_SIZE) {
                socket.output.write(Bytes.alloc(padding));
            }
        }

        // Mark the end of the TAR file (two empty blocks)
        socket.output.write(Bytes.alloc(BLOCK_SIZE * 2));
        socket.output.close();
    }

    static private function createHeader(fileName:String, fileSize:Int):Bytes {
        var header = Bytes.alloc(BLOCK_SIZE);

        // File name (100 byte)
        var nameBytes = Bytes.ofString(fileName);
        header.blit(0, nameBytes, 0, Std.int(Math.min(nameBytes.length, NAME_LENGTH)));
        if (nameBytes.length < NAME_LENGTH) {
            header.set(nameBytes.length, 0);
        }

        // File Mode (8 byte)
        header.blit(100, Bytes.ofString(DEFAULT_MODE), 0, 8);

        // Owner ID (8 byte)
        header.blit(108, Bytes.ofString("0000000" + NULL_CHAR), 0, 8);

        // Group ID (8 byte)
        header.blit(116, Bytes.ofString("0000000" + NULL_CHAR), 0, 8);

        // File size (12 byte, octal)
        var sizeStr = Std.string(fileSize).lpad('0', 11) + NULL_CHAR;
        header.blit(124, Bytes.ofString(sizeStr), 0, 12);

        // Last change time (12 byte)
        var modTime = Std.string(Math.floor(Date.now().getTime() / 1000));
        header.blit(136, Bytes.ofString(modTime.lpad('0', 11) + NULL_CHAR), 0, 12);

        // Fill the checksum field with spaces
        header.blit(148, Bytes.ofString("        "), 0, 8);

        // Link indicator (1 byte)
        header.set(156, 48);  // ASCII value

        // USTAR indicator
        header.blit(257, Bytes.ofString("ustar" + NULL_CHAR + "00"), 0, 8);

        // Calculate checksum
        var checksum = 0;
        for (i in 0...148) checksum += header.get(i);
        checksum += 32 * 8; // 8 space characters in checksum field
        for (i in 156...BLOCK_SIZE) checksum += header.get(i);

        // Write checksum (octal, 6 characters + NULL + space)
        var checksumStr = Std.string(checksum).lpad('0', 6) + NULL_CHAR + " ";
        header.blit(148, Bytes.ofString(checksumStr), 0, 8);

        return header;
    }
}