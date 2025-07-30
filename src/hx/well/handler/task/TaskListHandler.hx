package hx.well.handler.task;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using airpsx.tools.ResultSetTools;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;

class TaskListHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        return DBStatic.connection(DatabaseType.TASK).query('SELECT id, name, status, lastRun, enabled FROM tasks');
    }
}