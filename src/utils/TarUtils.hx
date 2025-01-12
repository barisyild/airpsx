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
        // Dosyaların her biri için tar başlıkları ve verileri yaz
        for (file in files) {
            var header = createHeader(file.fileName, file.length);

            // Başlık bilgisini yaz
            socket.output.write(header);
            // Dosya içeriğini yaz
            socket.output.writeInput(file.input);
            file.input.close();

            // Dosya uzunluğu 512 byte'lık bir blokta hizalanmalı
            var padding = BLOCK_SIZE - (file.length % BLOCK_SIZE);
            if (padding < BLOCK_SIZE) {
                socket.output.write(Bytes.alloc(padding));
            }
        }

        // TAR dosyasının sonunu işaretle (iki boş blok)
        socket.output.write(Bytes.alloc(BLOCK_SIZE * 2));
        socket.output.close();
    }

    static private function createHeader(fileName:String, fileSize:Int):Bytes {
        var header = Bytes.alloc(BLOCK_SIZE);

        // Dosya ismi (100 byte)
        var nameBytes = Bytes.ofString(fileName);
        header.blit(0, nameBytes, 0, Std.int(Math.min(nameBytes.length, NAME_LENGTH)));
        if (nameBytes.length < NAME_LENGTH) {
            header.set(nameBytes.length, 0);
        }

        // Dosya modu (8 byte)
        header.blit(100, Bytes.ofString(DEFAULT_MODE), 0, 8);

        // Owner ID (8 byte)
        header.blit(108, Bytes.ofString("0000000" + NULL_CHAR), 0, 8);

        // Group ID (8 byte)
        header.blit(116, Bytes.ofString("0000000" + NULL_CHAR), 0, 8);

        // Dosya boyutu (12 byte, octal)
        var sizeStr = Std.string(fileSize).lpad('0', 11) + NULL_CHAR;
        header.blit(124, Bytes.ofString(sizeStr), 0, 12);

        // Son değişiklik zamanı (12 byte)
        var modTime = Std.string(Math.floor(Date.now().getTime() / 1000));
        header.blit(136, Bytes.ofString(modTime.lpad('0', 11) + NULL_CHAR), 0, 12);

        // Checksum alanını boşluklarla doldur
        header.blit(148, Bytes.ofString("        "), 0, 8);

        // Link indicator (1 byte)
        header.set(156, 48);  // Doğrudan ASCII değeri

        // USTAR indicator
        header.blit(257, Bytes.ofString("ustar" + NULL_CHAR + "00"), 0, 8);

        // Checksum hesapla
        var checksum = 0;
        for (i in 0...148) checksum += header.get(i);
        checksum += 32 * 8; // 8 space characters in checksum field
        for (i in 156...BLOCK_SIZE) checksum += header.get(i);

        // Checksum'ı yaz (octal, 6 karakter + NULL + space)
        var checksumStr = Std.string(checksum).lpad('0', 6) + NULL_CHAR + " ";
        header.blit(148, Bytes.ofString(checksumStr), 0, 8);

        return header;
    }
}