package protocols.http.services.task;
import sys.net.Socket;
import protocols.http.HTTPRequest;
using tools.ResultSetTools;

class TaskListService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        socket.write("HTTP/1.1 200 OK\n");
        socket.write("Content-Type: application/json\n");
        socket.write("\n");

        var db = sys.db.Sqlite.open(Config.TASK_DB_PATH);
        var resultSet = db.request('SELECT id, name, status, lastRun, enabled FROM tasks');
        resultSet.writeJsonArray(socket, ["id", "name", "status", "lastRun", "enabled"]);
        db.close();
        return null;
    }
}