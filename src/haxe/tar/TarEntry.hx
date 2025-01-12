package haxe.tar;
import haxe.io.Input;
class TarEntry {
    public var name:String;
    public var isDirectory:Bool;
    public var input:Input;
    public var length:Int64;

    public function new() {

    }
}
