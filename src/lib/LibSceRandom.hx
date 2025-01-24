package lib;

#if orbis
import cpp.extern.ExternLibSceRandom;

class LibSceRandom {
    @:hscriptVariable("sceRandomGetRandomNumber")
    public static function getRandomNumber(array:Array<cpp.UInt8>):Void
    {
        ExternLibSceRandom.sceRandomGetRandomNumber(array, array.length);
    }
}
#end