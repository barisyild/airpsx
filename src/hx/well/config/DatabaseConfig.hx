package hx.well.config;
import haxe.ds.StringMap;
import airpsx.type.DatabaseType;
import airpsx.Const;
using Std;
class DatabaseConfig implements IConfig {
    public function new() {}

    public var connections:StringMap<ConnectionTypedef> = [
        DatabaseType.DEFAULT => {
            "driver": "sqlite",
            "path": Const.DB_PATH
        },
        DatabaseType.TASK => {
            "driver": "sqlite",
            "path": Const.TASK_DB_PATH
        },
        DatabaseType.APP => {
            "driver": "sqlite",
            "path": Const.SYSTEM_APP_DB_PATH
        },
        DatabaseType.SCRIPT_DB => {
            "driver": "sqlite",
            "path": Const.SCRIPT_DB_PATH
        },
    ];
}


typedef ConnectionTypedef = {
    driver:String,
    ?path:String,
    ?host:String,
    ?port:Int,
    ?username:String,
    ?password:String
}