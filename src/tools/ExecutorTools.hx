package tools;
import hx.concurrent.executor.Executor;
import hx.concurrent.executor.Schedule;

class ExecutorTools {
    public static function submitWithGC<T>(executor:Executor, callback:Void->T, ?schedule:Schedule):TaskFuture<T> {
        return cast executor.submit(() -> {
            var data:T = null;

            cpp.vm.Gc.compact();
            try
            {
                data = callback();
            }
            catch (e)
            {
                trace('Thread crashed: $e');
            }
            cpp.vm.Gc.compact();
            return data;
        }, schedule);
    }
}
