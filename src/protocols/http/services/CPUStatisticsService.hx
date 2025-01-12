package protocols.http.services;
import sys.net.Socket;
import sys.db.Sqlite;
import sys.db.ResultSet;
import haxe.Exception;
import Type.ValueType;
import protocols.http.HTTPRequest;
using tools.ResultSetTools;


// WIP
class CPUStatisticsService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var db = Sqlite.open(Config.DB_PATH);
        var resultSet:ResultSet = db.request("SELECT id, temperature, socSensorTemperature, frequency, titleID, timestamp FROM stats ORDER BY id DESC LIMIT 1000");

        var titleIDCache:Map<String, String> = new Map();

        socket.write("HTTP/1.1 200 OK\n");
        socket.write("Content-Type: application/json\n");
        socket.write("\n");
        try
        {
            resultSet.writeJsonArray(socket, ["id", "temperature", "socSensorTemperature", "frequency", "titleID", "timestamp"],  (data) -> {
                var titleID:String = data.titleID;
                if(titleID == "")
                    return;

                var titleName:String = null;

                if(titleIDCache.exists(titleID))
                {
                    titleName = titleIDCache.get(titleID);
                }else{
                    var db = sys.db.Sqlite.open(Config.SYSTEM_APP_DB_PATH);
                    try
                    {
                        var resultSet = db.request('SELECT titleName FROM tbl_contentinfo WHERE titleId = "${titleID}"');
                        titleName = resultSet.hasNext() ? resultSet.getResult(0) : null;
                        titleIDCache.set(titleID, titleName);
                    } catch (e)
                    {
                        titleIDCache.set(titleID, "");
                    }
                    db.close();

                    trace(titleName);
                }

                if(titleName != null)
                {
                    data.titleName = titleName;
                }
            });
        }
        catch (e:Exception)
        {
            trace(e.toString(), e.stack.toString());
        }

        db.close();

        return null;
    }
}
