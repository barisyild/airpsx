package cpp;

@:keep
@:include('thread')
extern class ThreadInfo {
    @:native('std::thread::hardware_concurrency')
    public static function hardwareConcurrency():UInt;
}