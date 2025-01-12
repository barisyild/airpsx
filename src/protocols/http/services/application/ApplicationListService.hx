package protocols.http.services.application;

#if orbis
import sys.net.Socket;
import sys.db.Sqlite;
import sys.db.ResultSet;
import cpp.Int64;
import protocols.http.HTTPRequest;
using tools.StringTools;
using tools.ResultSetTools;

class ApplicationListService extends AbstractHttpService {

    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        socket.output.writeString("HTTP/1.1 200 OK\n");
        socket.output.writeString("Content-Type: application/json\n");
        socket.output.writeString("\n");

        var db = Sqlite.open(Config.SYSTEM_APP_DB_PATH);
        var resultSet:ResultSet = db.request("SELECT titleId, titleName, size, installTime FROM tbl_contentinfo");
        resultSet.writeJsonArray(socket, ["titleId", "titleName", "size", "installTime"]);
        return null;
    }
}
#end