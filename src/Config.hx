package ;
using StringTools;
class Config {
    public static inline var APP_NAME:String = "AirPSX";
    public static #if orbis inline #end var DATA_PATH:String = #if !orbis Sys.programPath().substring(0, Sys.programPath().replace("\\", "/").lastIndexOf("/")) + #end "/data/airpsx";
    public static #if orbis inline #end var DB_PATH:String = '${DATA_PATH}/app.db';
    public static #if orbis inline #end var TASK_DB_PATH:String = '${DATA_PATH}/task.db';
    public static inline var HTTP_PORT:Int = 1214;
    public static inline var SYSTEM_APP_DB_PATH = "/system_data/priv/mms/app.db";
    public static inline var USER_HOME_PATH:String = "/user/home";

    public static var storageDirectories:Map<String, String> = new Map<String, String>();

    public static function init():Void {
        for(i in 0...8) {
            storageDirectories.set("/mnt/usb" + i, "USB Storage");
        }
        storageDirectories.set("/mnt/ext0", "External Storage");
        storageDirectories.set("/user", "User Storage", );
        storageDirectories.set("/mnt/disc", "Disc Storage");
    }
}