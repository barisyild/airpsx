package airpsx.tools;
import sys.io.FileInput;
import haxe.io.PartialFileInput;
import haxe.io.UncloseableInputWrapper;
import haxe.io.Input;
class InputTools {
    public static function range(fileInput:FileInput, start:Int, end:Int):PartialFileInput {
        return new PartialFileInput(fileInput, start, end);
    }

    public static function asUncloseable(input:Input):UncloseableInputWrapper {
        return new UncloseableInputWrapper(input);
    }
}