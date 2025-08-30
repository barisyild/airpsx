package hx.well.config;
import haxe.ds.StringMap;
import hx.well.auth.IAuthenticatable;
import hx.well.facades.Environment.Environment.env;
using Std;

class SessionConfig implements IConfig {
    public function new() {}

    public var path:String = env("SESSION_PATH", "session");
    public var lifetime:Int = env("SESSION_LIFETIME", "360").parseInt();

    public var guards:StringMap<Class<IAuthenticatable>> = new StringMap();
}
