package protocols.http.services.task;
import sys.net.Socket;
import command.SchedulerCommand;
import protocols.http.HTTPRequest;
using tools.ResultSetTools;

class TaskStatusService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        //var runningTaskData = SchedulerCommand.taskData;
        //var runningTaskId = runningTaskData != null ? runningTaskData.id : null;

        var db = sys.db.Sqlite.open(Config.TASK_DB_PATH);
        var resultSet = db.request('SELECT id, lastRun, status FROM tasks');
        if(!resultSet.hasNext())
        {
            db.close();
            return {};
        }

        socket.write("HTTP/1.1 200 OK\r\n");
        socket.write("Content-Type: application/json\r\n");
        socket.write("\r\n");

        resultSet.writeJsonArray(socket, ["id", "lastRun", "status"]);

        db.close();



        return null;
    }
}