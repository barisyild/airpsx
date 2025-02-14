package airpsx.service.task;
import sys.net.Socket;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using tools.ResultSetTools;
import hx.well.http.RequestStatic.socket;
import hx.well.facades.DBStatic;
import type.DatabaseType;

class TaskStatusService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        //var runningTaskData = SchedulerCommand.taskData;
        //var runningTaskId = runningTaskData != null ? runningTaskData.id : null;

        var resultSet = DBStatic.connection(DatabaseType.TASK).query('SELECT id, lastRun, status FROM tasks');
        if(!resultSet.hasNext())
            return {};
        return resultSet;
    }
}