package cpp;

#if orbis
import cpp.CastCharStar;
import cpp.SizeT;

@:keep
@:native('pid_t')
@:unreflective
@:scalar @:coreType @:notNull
extern abstract PidT from(Int) to(Int) {}
#end