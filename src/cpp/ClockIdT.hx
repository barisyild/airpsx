package cpp;

#if orbis

@:keep
@:native('clockid_t')
@:unreflective
@:scalar @:coreType @:notNull
extern abstract ClockIdT from(Int) to(Int) {}
#end