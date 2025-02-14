package airpsx.service.task;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import type.DatabaseType;
class TaskDetailService extends AbstractService {
    public static var instance:TaskDetailService;

    public function new() {
        super();
        instance = this;
    }

    public function execute(request:Request):AbstractResponse {
        var jsonData:Dynamic = haxe.Json.parse(request.bodyBytes.toString());
        var id:Int = Std.parseInt(jsonData.id);

        var resultSet = DBStatic.connection(DatabaseType.TASK).query('SELECT * FROM tasks WHERE id = ?', id);
        if(!resultSet.hasNext())
            return {"message": "Task not found"};

        return resultSet.next();
    }
}