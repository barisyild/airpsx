package hx.well.handler.task;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using airpsx.tools.ResultSetTools;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;

class TaskStatusHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        //var runningTaskData = SchedulerCommand.taskData;
        //var runningTaskId = runningTaskData != null ? runningTaskData.id : null;

        var resultSet = DBStatic.connection(DatabaseType.TASK).query('SELECT id, lastRun, status FROM tasks');
        if(!resultSet.hasNext())
            return {};
        return resultSet;
    }
}