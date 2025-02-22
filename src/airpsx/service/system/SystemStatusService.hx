package airpsx.service.system;

#if orbis
import cpp.lib.LibKernel;
import sys.net.Socket;
import cpp.lib.Systemctl;
import cpp.lib.Process;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;

// This service returns variable system resources.
class SystemStatusService extends AbstractService {
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
            var db = DBStatic.connection(DatabaseType.APP);
            try
            {
                var resultSet = db.query('SELECT titleName FROM tbl_contentinfo WHERE titleId = ?', runningApp.titleID);
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