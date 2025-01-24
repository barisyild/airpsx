package cpp.extern;

#if orbis
import cpp.Pointer;
import cpp.CastCharStar;
import cpp.Int32;
import cpp.RawConstPointer;
import cpp.ConstCharStar;
import cpp.SizeT;
import cpp.AbstractPointer;

@:keep
@:include('libSceUserService.h')
@:build(Linc.touch())
@:build(Linc.xml('libSceUserService'))
extern class ExternLibSceUserService {
    @:native('sceUserServiceGetLoginUserIdList')
    public static function sceUserServiceGetLoginUserIdList(struct:AbstractPointer<SceUserServiceLoginStruct>):Int32;

    @:native('sceUserServiceInitialize')
    public static function sceUserServiceInitialize(?param:AbstractPointer<cpp.Void>):Int32;
} //Empty


@:keep
@:include('libSceUserService.h')
@:native('SceUserServiceLogin_struct')
@:structAccess
@:unreflective
extern class SceUserServiceLoginStruct {
    public var userId:RawConstPointer<Int32>;

    public static inline function create(): SceUserServiceLoginStruct {
        return untyped __cpp__('{}');//untyped __cpp__('malloc(sizeof(SceUserServiceLogin_struct))');
    }

    public static inline function empty():SceUserServiceLoginStruct {
        return untyped __cpp__('nullptr');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(SceUserServiceLoginStruct);
    }
}
#end