package airpsx.tools;
import sys.io.FileInput;
import haxe.io.PartialFileInput;
class InputTools {
    public static function range(fileInput:FileInput, start:Int, end:Int):PartialFileInput {
        return new PartialFileInput(fileInput, start, end);
    }
}