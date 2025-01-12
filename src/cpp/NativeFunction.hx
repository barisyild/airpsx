package cpp;

@:callable
extern abstract NativeFunction<T>(Function<T, cpp.abi.Abi>) to(Function<T, cpp.abi.Abi>) {
    inline function new<T>(value:AutoCast)
        this = cast value;

    @:from
    static public inline function fromDynamic<T>(value:AutoCast):NativeFunction<T>
    return cast new NativeFunction<T>(value);

    @:to
    public inline function toFunction<T>():Function<T, cpp.abi.Abi>
        return cast this;
}