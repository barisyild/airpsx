package airpsx.command;
import hx.well.console.AbstractCommand;
import utils.NTPUtils;
import lib.LibKernel;
import lib.sys.LibSysTime;
import hx.well.facades.Schedule;
class TimestampUpdateCommand extends AbstractCommand {
    public override function group():String {
        return "timestamp";
    }

    public function signature():String {
        return "update";
    }

    public function description():String {
        return "Update console timestamp";
    }

    public function handle<T>():T {
        var ntpSeconds = NTPUtils.readTime().seconds;
        var systemSeconds = Sys.time();

        var diff = ntpSeconds - systemSeconds;
        if(diff > 60 || diff < -60) {
            LibKernel.sendNotificationRequest('System time was synchronized via the NTP server because it was out of date.');
            #if orbis
            LibSysTime.setTime(ntpSeconds);
            #end
        }

        future.cancel();
        #if orbis
        Schedule.get().fixedRate("temperature:log", 60000);
        #end

        Schedule.get().fixedRate("task:execute", 60000, 60000);

        return cast true;
    }
}
