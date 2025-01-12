package cpp;

#if orbis

@:keep
@:native('fsblkcnt_t')
@:unreflective
@:scalar @:coreType @:notNull
extern abstract FsblkcntT from(Int64) to(Int64) {}
#end