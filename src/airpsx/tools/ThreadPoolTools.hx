package airpsx.tools;
import sys.thread.IThreadPool;
class ThreadPoolTools {
    public static function runWithGC(threadPool:IThreadPool, task:()->Void):Void {
        threadPool.run(() -> {
            cpp.vm.Gc.compact();
            try
            {
                task();
            }
            catch (e)
            {
                trace('Thread crashed: $e');
            }
            cpp.vm.Gc.compact();
        });
    }
}
