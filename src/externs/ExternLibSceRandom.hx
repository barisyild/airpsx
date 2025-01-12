package externs;

#if orbis
import cpp.AbstractPointer;
import cpp.CastCharStar;
import cpp.ConstCharStar;
import cpp.Int32;
import cpp.Int32Pointer;
import cpp.Int64;
import cpp.PidT;
import cpp.SizeT;
import cpp.UInt32;
import cpp.UInt64;
import cpp.Pointer;
import cpp.UInt8;
import cpp.AbstractArrayPointer;

@:keep
@:include('libSceRandom.h')
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('libSceRandom'))
extern class ExternLibSceRandom {
    @:native('sceRandomGetRandomNumber')
    public static function sceRandomGetRandomNumber(buf:AbstractArrayPointer<cpp.UInt8>, size:SizeT):Int32;
}
#end