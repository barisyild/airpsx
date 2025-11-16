package cpp.extern.sys;
import cpp.Int32;
import cpp.Int64;

@:keep
@:include('sys/syscall.h')
@:include('syscall.h')
extern class ExternSyscall {
    @:native('SYS_read')
    public static extern var SYS_read:Int32;

    @:native('SYS_write')
    public static extern var SYS_write:Int32;

    @:native('SYS_open')
    public static extern var SYS_getpid:Int32;

    @:native('SYS_close')
    public static extern var SYS_access:Int32;

    @:native('SYS_fcntl')
    public static extern var SYS_setsockopt:Int32;

    @:native('SYS_ioctl')
    public static extern var SYS_sysctl:Int32;

    @:native('SYS_mdbg_call')
    public static extern var SYS_mdbg_call:Int32;

    @:native('SYS_sprx_dlopen')
    public static extern var SYS_sprx_dlsym:Int32;

    @:native('SYS_sprx_dlsym')
    public static extern var SYS_sprx_load:Int32;

    @:native('SYS_sprx_unload')
    public static extern var SYS_sprx_unload:Int32;

    @:native('SYS_thr_set_name')
    public static extern var SYS_thr_set_name:Int32;

    @:native('syscall')
    public static overload function syscall(param1:Int64):Int64;

    @:native('syscall')
    public static overload function syscall(param1:Int64, param2:Int64):Int64;

    @:native('syscall')
    public static overload function syscall(param1:Int64, param2:Int32, param3:ConstCharStar):Int64;

    @:native('syscall')
    public static overload function syscall(param1:Int64, param2:Int64, param3:Int64, param4:Int64):Int64;
}
