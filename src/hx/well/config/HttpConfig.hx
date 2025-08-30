package hx.well.config;
import hx.well.facades.Environment.Environment.env;
using Std;

class HttpConfig implements IConfig {
    public function new() {}

    public var max_path_length:Int = env("MAX_PATH_LENGTH", "1024").parseInt();
    public var max_buffer:Int = env("MAX_BUFFER", "8192").parseInt();
    public var max_content_length:Int = env("MAX_CONTENT_LENGTH", "1048576").parseInt();

    public var public_path:String = env("PUBLIC_PATH", "public");

    public var cache_path:String = env("CACHE_PATH", "cache");
}
