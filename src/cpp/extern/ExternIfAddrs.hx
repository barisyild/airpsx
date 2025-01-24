package cpp.extern;

#if orbis
import cpp.CastCharStar;
import cpp.Pointer;
import cpp.Int32;
import cpp.UInt32;
//import cpp.extern.sys.ExternSocket;
import cpp.SizeT;

@:cppFileCode('extern int getifaddrs(struct ifaddrs **);')

@:keep
@:include('ifaddrs.h')
extern class ExternIfAddrs {
    @:native('getifaddrs')
    public static function getifaddrs(ifap:Pointer<Pointer<IfAddrsStruct>>):Int32;
}

@:keep
@:include('ifaddrs.h')
@:native('ifaddrs')
@:structAccess
@:unreflective
extern class IfAddrsStruct {
    public var ifa_next:Pointer<IfAddrsStruct>;
    public var ifa_name:CastCharStar;
    public var ifa_flags:UInt32;
    public var ifa_addr:Pointer<Dynamic>;
    public var ifa_netmask:Pointer<Dynamic>;
    public var ifa_dstaddr:Pointer<Dynamic>;
    public var ifa_data:Pointer<Void>;

    public static inline function create(): IfAddrsStruct {
        return untyped __cpp__('{}');
    }

    public static inline function size():SizeT {
        return cpp.Native.sizeof(IfAddrsStruct);
    }
}
#end