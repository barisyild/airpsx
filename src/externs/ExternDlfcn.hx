package externs;

#if orbis
import cpp.Pointer;
import cpp.Int32;
import cpp.Int32Pointer;
import cpp.ConstCharStar;

// void	*dlsym(void * __restrict, const char * __restrict);

@:keep
@:include('dlfcn.h')
extern class ExternDlfcn {
    @:native('dlopen')
    public static function dlopen(filename:ConstCharStar, flag:Int32):Pointer<cpp.Void>;

    @:native('dlsym')
    public static function dlsym(handle:Pointer<cpp.Void>, symbol:ConstCharStar):Pointer<Void>;

    @:native('dlclose')
    public static function dlclose(handle:Pointer<cpp.Void>):Int32;
}
#end