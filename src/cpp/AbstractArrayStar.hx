package cpp;

abstract AbstractArrayStar<T>(Star<T>) to(Star<T>) {
    inline function new(value:Array<T>)
        this = cast Pointer.ofArray(value);

    @:from
    static public inline function fromInt32<T>(value:Array<T>)
        return new AbstractArrayStar(value);

    @:to
    public inline function toPointer()
        return this;
}
