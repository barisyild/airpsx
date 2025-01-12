package haxe.io;
import haxe.io.Output;
import haxe.io.Bytes;
import haxe.io.Input;
import haxe.io.Encoding;
class NullOutput extends Output {
    public function new() {

    }

    public override function writeByte(c:Int):Void {

    }

    public override function writeBytes(s:Bytes, pos:Int, len:Int):Int {
        return len;
    }

    public override function flush() {}

    public override function close() {}

    public override function write(s:Bytes):Void {

    }

    public override function writeFullBytes(s:Bytes, pos:Int, len:Int) {

    }

    public override function writeFloat(x:Float) {

    }


    public override function writeDouble(x:Float) {

    }

    public override function writeInt8(x:Int) {

    }


    public override function writeInt16(x:Int) {

    }


    public override function writeUInt16(x:Int) {

    }


    public override function writeInt24(x:Int) {

    }

    public override function writeUInt24(x:Int) {

    }

    public override function writeInt32(x:Int) {

    }

    public override function prepare(nbytes:Int) {}

    public override function writeInput(i:Input, ?bufsize:Int) {

    }

    public override function writeString(s:String, ?encoding:Encoding) {

    }
}
