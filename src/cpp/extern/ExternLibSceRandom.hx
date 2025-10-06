package cpp.extern;

#if orbis
import cpp.Int32;
import cpp.SizeT;
import cpp.AbstractArrayPointer;

@:keep
@:include('libSceRandom.h')
extern class ExternLibSceRandom {
    @:native('sceRandomGetRandomNumber')
    public static function sceRandomGetRandomNumber(buf:AbstractArrayPointer<cpp.UInt8>, size:SizeT):Int32;
}
#end