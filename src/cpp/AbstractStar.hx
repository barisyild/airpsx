package cpp;

abstract AbstractStar<T>(Star<T>) to(Star<T>) {
    inline function new(value:T)
        this = cast Pointer.addressOf(value);

    @:from
    static public inline function fromStruct<T>(value:T)
        return new AbstractStar(value);

    @:to
    public inline function toPointer()
        return this;
}