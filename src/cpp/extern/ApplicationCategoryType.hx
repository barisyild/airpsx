package cpp.extern;
import cpp.Int32;

enum abstract ApplicationCategoryType(Int32) from Int32 to Int32 {
    var NATIVE_GAME = 0;
    var PROSPERO_NATIVE_MEDIA_APP = 65536;
    var RNPS_MEDIA_APP = 65792;
    var WEB_BASED_MEDIA_APP = 66048;
    var SYSTEM_BUILTIN_APP = 131328;
    var BIG_DAEMON = 131584;
    var SHELL_UI = 16777216;
    var DAEMON = 33554432;
    var COMMON_DIALOG = 50331648;
    var SHELL_APP = 67108864;
}
