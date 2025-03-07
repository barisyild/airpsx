package cpp.lib;

#if cpp
enum abstract LncAppErrorType(cpp.UInt32) from cpp.UInt32 to cpp.UInt32
{
    var SCE_LNC_ERROR_APP_NOT_FOUND = 0x80940031;
    var SCE_LNC_UTIL_ERROR_ALREADY_INITIALIZED = 0x80940018;
    var SCE_LNC_UTIL_ERROR_ALREADY_RUNNING = 0x8094000c;
    var SCE_LNC_UTIL_ERROR_ALREADY_RUNNING_KILL_NEEDED = 0x80940010;
    var SCE_LNC_UTIL_ERROR_ALREADY_RUNNING_SUSPEND_NEEDED = 0x80940011;
    var SCE_LNC_UTIL_ERROR_APP_ALREADY_RESUMED = 0x8094001e;
    var SCE_LNC_UTIL_ERROR_APP_ALREADY_SUSPENDED = 0x8094001d;
    var SCE_LNC_UTIL_ERROR_APP_NOT_IN_BACKGROUND = 0x80940015;
    var SCE_LNC_UTIL_ERROR_APPHOME_EBOOTBIN_NOT_FOUND = 0x80940008;
    var SCE_LNC_UTIL_ERROR_APPHOME_PARAMSFO_NOT_FOUND = 0x80940009;
    var SCE_LNC_UTIL_ERROR_CANNOT_RESUME_INITIAL_USER_NEEDED = 0x80940012;
    var SCE_LNC_UTIL_ERROR_DEVKIT_EXPIRED = 0x8094000b;
    var SCE_LNC_UTIL_ERROR_IN_LOGOUT_PROCESSING = 0x8094001a;
    var SCE_LNC_UTIL_ERROR_IN_SPECIAL_RESUME = 0x8094001b;
    var SCE_LNC_UTIL_ERROR_INVALID_PARAM = 0x80940005;
    var SCE_LNC_UTIL_ERROR_INVALID_STATE = 0x80940019;
    var SCE_LNC_UTIL_ERROR_INVALID_TITLE_ID = 0x8094001c;
    var PROCCESS_STARTER_OP_NOT_SUPPORTED  = 0x80a40017;
    var SCE_PROCESS_STARTER_ERROR_PS4_BLACK_LIST = 0x80A40086;
    var SCE_NP_TROPHY_ERROR_NPCOMMSIGN_NOT_FOUND = 0x805516F9;
    var SCE_LNC_UTIL_ERROR_LAUNCH_DISABLED_BY_MEMORY_MODE = 0x8094000d;
    var SCE_LNC_UTIL_ERROR_NO_APP_INFO = 0x80940004;
    var SCE_LNC_UTIL_ERROR_NO_LOGIN_USER = 0x8094000a;
    var SCE_LNC_UTIL_ERROR_NO_SESSION_MEMORY = 0x80940002;
    var SCE_LNC_UTIL_ERROR_NO_SFOKEY_IN_APP_INFO = 0x80940014;
    var SCE_LNC_UTIL_ERROR_NO_SHELL_UI = 0x8094000e;
    var SCE_LNC_UTIL_ERROR_NOT_ALLOWED = 0x8094000f;
    var SCE_LNC_UTIL_ERROR_NOT_INITIALIZED = 0x80940001;
    var SCE_LNC_UTIL_ERROR_OPTICAL_DISC_DRIVE = 0x80940013;
    var SCE_LNC_UTIL_ERROR_SETUP_FS_SANDBOX = 0x80940006;
    var SCE_LNC_UTIL_ERROR_SUSPEND_BLOCK_TIMEOUT = 0x80940017;
    var SCE_LNC_UTIL_ERROR_VIDEOOUT_NOT_SUPPORTED = 0x80940016;
    var SCE_LNC_UTIL_ERROR_WAITING_READY_FOR_SUSPEND_TIMEOUT = 0x80940021;
    var SCE_SYSCORE_ERROR_LNC_INVALID_STATE = 0x80aa000a;
}
#end