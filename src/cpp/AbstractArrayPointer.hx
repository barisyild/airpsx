package cpp;

abstract AbstractArrayPointer<T>(Pointer<T>) to(Pointer<T>) {
    inline function new(value:Array<T>)
        this = cast Pointer.ofArray(value);

    @:from
    static public inline function fromArray<T>(value:Array<T>)
        return new AbstractArrayPointer(value);

    @:to
    public inline function toPointer()
        return this;
}
