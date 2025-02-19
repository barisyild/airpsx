package airpsx.tools;

import haxe.io.Input;
import haxe.io.Output;
import haxe.Int64;
import haxe.io.Bytes;

class OutputTools {
    public static function writeInputSize(output:Output, input:Input, size:Int64, ?bufsize:Int):Void {
        if (bufsize == null)
            bufsize = 4096;

        var buffer:Bytes = haxe.io.Bytes.alloc(bufsize);
        while (size > 0)
        {
            var allocateSize:Int = Std.int(Math.min(bufsize, Int64.toInt(size)));
            var bytesRead:Int = input.readBytes(buffer, 0, allocateSize);
            if (bytesRead == 0)
                break;

            output.writeBytes(buffer, 0, bytesRead);
            size -= bytesRead;
        }
    }
}
