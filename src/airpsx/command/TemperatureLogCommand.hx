package airpsx.command;
import hx.well.console.AbstractCommand;
import hx.well.facades.DBStatic;
#if orbis
import lib.LibKernel;
import lib.Process;
#end

class TemperatureLogCommand extends AbstractCommand {
    public override function group():String {
        return "temperature";
    }

    public function signature():String {
        return "log";
    }

    public function description():String {
        return "log temperature";
    }

    public function handle<T>():T {
        #if orbis
        var socSensorTemperature:Int = LibKernel.getSocSensorTemperature();
        var temperature:Int = LibKernel.cpuTemperature;
        var frequency = LibKernel.cpuFrequency;

        var runningApp = Process.getRunningApp();
        var titleID = runningApp != null ? runningApp.titleID : "";

        trace('socSensorTemperature: ${socSensorTemperature}');
        trace('temperature: ${temperature}');
        trace('frequency: ${frequency}');
        trace('titleID: ${titleID}');

        DBStatic.query('INSERT INTO stats (socSensorTemperature, temperature, frequency, titleID) VALUES (?, ?, ?, ?);', socSensorTemperature, temperature, frequency, titleID);
        #end

        return cast true;
    }
}
