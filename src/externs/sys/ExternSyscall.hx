package externs.sys;
import cpp.Int32;
import cpp.Int64;

@:keep
@:include('sys/syscall.h')
@:include('syscall.h')
extern class ExternSyscall {
    public static inline var SYS_read:Int32 = 3;
    public static inline var SYS_write:Int32 = 4;
    public static inline var SYS_getpid:Int32 = 20;
    public static inline var SYS_access:Int32 = 33;
    public static inline var SYS_setsockopt:Int32 = 105;
    public static inline var SYS_sysctl:Int32 = 202;
    public static inline var SYS_mdbg_call:Int32  = 573;
    public static inline var SYS_sprx_dlsym:Int32 = 591;
    public static inline var SYS_sprx_load:Int32 = 594;
    public static inline var SYS_sprx_unload:Int32 = 595;

    @:native('syscall')
    public static overload function syscall(param1:Int64):Int64;

    @:native('syscall')
    public static overload function syscall(param1:Int64, param2:Int64):Int64;

    @:native('syscall')
    public static overload function syscall(param1:Int64, param2:Int64, param3:Int64):Int64;

    @:native('syscall')
    public static overload function syscall(param1:Int64, param2:Int64, param3:Int64, param4:Int64):Int64;
}
