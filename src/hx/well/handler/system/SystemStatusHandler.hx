package hx.well.handler.system;

#if orbis
import cpp.lib.LibKernel;
import sys.net.Socket;
import cpp.lib.Systemctl;
import cpp.lib.Process;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;

// This service returns variable system resources.
class SystemStatusHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var response:Dynamic = {};
        response.cpu = {
            socSensorTemperature: LibKernel.getSocSensorTemperature(),
            temperature: LibKernel.cpuTemperature,
            frequency: LibKernel.cpuFrequency,
            mode: Systemctl.kernelCpuMode,
            mode_game: Systemctl.kernelCpuModeGame
        };

        var runningApp = Process.getRunningApp();
        if(runningApp != null)
        {
            var titleName:String = "";
            var titleID:String = runningApp.titleID;
            try
            {
                #if prospero
                var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT titleName FROM tbl_contentinfo WHERE titleId = ?', titleID);
                #else
                var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT val as titleName FROM tbl_appinfo WHERE titleId = ? AND key = "TITLE"', titleID);
                #end
                titleName = resultSet.hasNext() ? resultSet.getResult(0) : null;
            } catch (e)
            {

            }

            response.app = {
                pid: runningApp.pid,
                comm: runningApp.comm,
                titleID: runningApp.titleID,
                start: runningApp.start,
                titleName: titleName
            }
        }

        return response;
    }
}
#end