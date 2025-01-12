package cpp;

abstract AbstractPointer<T>(Pointer<T>) to(Pointer<T>) {
    inline function new(value:T)
        this = cast Pointer.addressOf(value);

    @:from
    static public inline function fromStruct<T>(value:T)
        return new AbstractPointer(value);

    @:to
    public inline function toPointer()
        return this;
}