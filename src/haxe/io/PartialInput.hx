package haxe.io;
class PartialInput extends Input {
    private var input:Input;
    private var size:Int64;

    public function new(input:Input, size:Int64):Void {
        this.input = input;
        this.size = size;
    }

    public override function readByte():Int {
        return input.readByte();
    }

    public override function readBytes(s:Bytes, pos:Int, len:Int):Int {
        if(len > size) {
            len = cast size;
        }

        if(len == 0)
            throw new Eof();

        var read = input.readBytes(s, pos, len);
        size-= read;
        return read;
    }

    public override function close():Void {
        input.close();
        super.close();
    }
}