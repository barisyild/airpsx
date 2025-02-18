package airpsx.service.task;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using tools.ResultSetTools;
import hx.well.facades.DBStatic;
import type.DatabaseType;

class TaskListService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        return DBStatic.connection(DatabaseType.TASK).query('SELECT id, name, status, lastRun, enabled FROM tasks');
    }
}