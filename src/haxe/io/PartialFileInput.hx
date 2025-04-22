package haxe.io;
import sys.io.FileInput;
class PartialFileInput extends Input {
    private var input:FileInput;
    private var len:Int;

    public function new(input:FileInput, start:Int, end:Int):Void {
        this.input = input;
        input.seek(start, sys.io.FileSeek.SeekBegin);

        this.len = end - start + 1;
    }

    public override function readByte():Int {
        return input.readByte();
    }

    public override function readBytes(s:Bytes, pos:Int, len:Int):Int {
        if(len > this.len) {
            len = this.len;
        }

        if(len == 0)
            throw new Eof();

        var read = input.readBytes(s, pos, len);
        this.len -= read;
        return read;
    }

    public override function close():Void {
        input.close();
        super.close();
    }
}
