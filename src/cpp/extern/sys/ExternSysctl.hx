package cpp.extern.sys;

import cpp.Pointer;
import cpp.RawPointer;
import cpp.CastCharStar;
import cpp.SizeT;
import cpp.Int32;
import cpp.UInt8;
import cpp.UInt32;
import cpp.Void;
import cpp.Int32Pointer;
import cpp.Int32ArrayPointer;
import cpp.AbstractPointer;

@:keep
@:include('sys/sysctl.h')
extern class ExternSysCtl {
    // sysctl(const int *, u_int, void *, size_t *, const void *, size_t)
    @:native('sysctl')
    public static function sysctl(a:Int32ArrayPointer, b:UInt32, c:RawPointer<UInt8>, d:AbstractPointer<SizeT>, e:AbstractPointer<Void>, f:SizeT):Int32;

    @:native('sysctlbyname')
    public static function sysctlbyname(name:CastCharStar, oldp:CastCharStar, oldlenp:AbstractPointer<SizeT>, newp:AbstractPointer<Void>, newlen:SizeT):Int32;
} //Empty