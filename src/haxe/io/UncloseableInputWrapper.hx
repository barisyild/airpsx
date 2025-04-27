package haxe.io;

class UncloseableInputWrapper extends Input {
    private var input:Input;

    public function new(input:Input) {
        this.input = input;
    }

    public override function readByte():Int {
        return input.readByte();
    }

    public override function readBytes(s:Bytes, pos:Int, len:Int):Int {
        return input.readBytes(s, pos, len);
    }

    public override function close():Void {

    }

    override function set_bigEndian(b:Bool):Bool {
        return input.bigEndian = b;
    }

    public override function readAll(?bufsize:Int):Bytes {
        return input.readAll(bufsize);
    }

    public override function readFullBytes(s:Bytes, pos:Int, len:Int):Void {
        return input.readFullBytes(s, pos, len);
    }

    public override function read(nbytes:Int):Bytes {
        return input.read(nbytes);
    }

    public override function readUntil(end:Int):String {
        return input.readUntil(end);
    }

    public override function readLine():String {
        return input.readLine();
    }

    public override function readFloat():Float {
        return input.readFloat();
    }

    public override function readDouble():Float {
        return input.readDouble();
    }

    public override function readInt8():Int {
        return input.readInt8();
    }

    public override function readInt16():Int {
        return input.readInt16();
    }

    public override function readUInt16():Int {
        return input.readUInt16();
    }

    public override function readInt24():Int {
        return input.readInt24();
    }

    public override function readUInt24():Int {
        return input.readUInt24();
    }

    public override function readInt32():Int {
        return input.readInt32();
    }

    public override function readString(len:Int, ?encoding:Encoding):String {
        return input.readString(len, encoding);
    }
}