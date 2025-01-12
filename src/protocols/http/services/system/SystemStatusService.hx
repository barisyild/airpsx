package protocols.http.services.system;

#if orbis
import lib.LibKernel;
import sys.net.Socket;
import lib.Systemctl;
import lib.Process;
import protocols.http.HTTPRequest;

// This service returns variable system resources.
class SystemStatusService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
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
            var db = sys.db.Sqlite.open(Config.SYSTEM_APP_DB_PATH);
            try
            {
                var resultSet = db.request('SELECT titleName FROM tbl_contentinfo WHERE titleId = "${runningApp.titleID}"');
                titleName = resultSet.hasNext() ? resultSet.getResult(0) : null;
            } catch (e)
            {

            }
            db.close();

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