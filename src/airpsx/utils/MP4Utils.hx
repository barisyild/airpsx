package airpsx.utils;

import sys.io.FileInput;

import sys.io.File;
class MP4Utils {
    public static function getDuration(filePath:String):Null<Float> {
        var file = File.read(filePath, true);
        file.bigEndian = true;

        try {
            // moov box'ını bul
            var moovPos = findBox(file, "moov");
            if (moovPos == null) {
                file.close();
                return null;
            }

            file.seek(moovPos, SeekBegin);
            var moovSize = file.readInt32();

            // mvhd box'ını moov içinde ara
            var mvhdPos = findBox(file, "mvhd", moovPos + 8, moovPos + moovSize);
            if (mvhdPos == null) {
                file.close();
                return null;
            }

            file.seek(mvhdPos, SeekBegin);
            var mvhdSize = file.readInt32();
            var mvhdType = file.readString(4);

            // Version byte'ını oku
            var version = file.readByte();

            // Flags (3 bytes)
            file.readByte();
            file.readByte();
            file.readByte();

            var timescale:Int;
            var duration:Int;

            if (version == 1) {
                // 64-bit version
                file.readInt32(); // creation_time high
                file.readInt32(); // creation_time low
                file.readInt32(); // modification_time high
                file.readInt32(); // modification_time low
                timescale = file.readInt32();
                var durationHigh = file.readInt32();
                var durationLow = file.readInt32();
                duration = durationLow; // Basitleştirme için sadece low kısmı
            } else {
                // 32-bit version
                file.readInt32(); // creation_time
                file.readInt32(); // modification_time
                timescale = file.readInt32();
                duration = file.readInt32();
            }

            file.close();
            return duration / timescale;
        } catch (e:Dynamic) {
            file.close();
            trace('Hata: $e');
            return null;
        }
    }

    static function findBox(file:FileInput, boxType:String, ?start:Int = 0, ?end:Int):Null<Int> {
        if (end == null) {
            // Dosya boyutunu öğren
            var currentPos = file.tell();
            file.seek(0, SeekEnd);
            end = file.tell();
            file.seek(currentPos, SeekBegin);
        }

        file.seek(start, SeekBegin);
        var pos = start;

        while (pos < end - 8) {
            file.seek(pos, SeekBegin);
            var size = file.readInt32();
            var type = file.readString(4);

            if (type == boxType) {
                return pos;
            }

            if (size < 8) break; // Geçersiz size
            pos += size;
        }

        return null;
    }
}