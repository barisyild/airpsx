package cpp.extern;

#if orbis
@:keep
@:include('libjbc.h')
extern class ExternLibJbc {
    @:native('jbc_get_cred')
    public static function jbc_get_cred(jbc_cred:AbstractPointer<JbcCredStruct>):Int32;

    @:native('jbc_jailbreak_cred')
    public static function jbc_jailbreak_cred(jbc_cred:AbstractPointer<JbcCredStruct>):Int32;

    @:native('jbc_set_cred')
    public static function jbc_set_cred(jbc_cred:AbstractPointer<JbcCredStruct>):Int32;

    @:native('is_jailbroken')
    public static function is_jailbroken():Bool;
} //Empty

@:keep
@:include('libjbc.h')
@:native('jbc_cred')
@:structAccess
@:unreflective
extern class JbcCredStruct {
    public static inline function create(): JbcCredStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(JbcCredStruct);
    }

    @:native('uid')
    public var uid:UInt32;

    @:native('ruid')
    public var ruid:UInt32;

    @:native('svuid')
    public var svuid:UInt32;

    @:native('rgid')
    public var rgid:UInt32;

    @:native('svgid')
    public var svgid:UInt32;

    @:native('prison')
    public var prison:UInt64;

    @:native('cdir')
    public var cdir:UInt64;

    @:native('rdir')
    public var rdir:UInt64;

    @:native('jdir')
    public var jdir:UInt64;

    @:native('sceProcType')
    public var sceProcType:UInt64;

    @:native('sonyCred')
    public var sonyCred:UInt64;

    @:native('sceProcCap')
    public var sceProcCap:UInt64;
}
#end