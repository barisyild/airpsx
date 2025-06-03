package cpp.lib;

#if orbis
import cpp.extern.ExternLibSceRandom;

class LibSceRandom {
    @:hscriptVariable("sceRandomGetRandomNumber")
    public static function getRandomNumber(array:Array<cpp.UInt8>):Array<cpp.UInt8>
    {
        ExternLibSceRandom.sceRandomGetRandomNumber(array, array.length);
        return array;
    }
}
#end