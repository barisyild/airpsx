package airpsx.service.task;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import hx.well.validator.ValidatorRule;
import hx.well.http.RequestStatic.request;

class TaskDetailService extends AbstractService {
    public static var instance:TaskDetailService;

    public function validator():Bool {
        return request().validate([
            "id" => [ValidatorRule.Required, ValidatorRule.Int]
        ]);
    }

    public function new() {
        super();
        instance = this;
    }

    public function execute(request:Request):AbstractResponse {
        var id:Int = request.input("id");

        var resultSet = DBStatic.connection(DatabaseType.TASK).query('SELECT * FROM tasks WHERE id = ?', id);
        if(!resultSet.hasNext())
            return {"message": "Task not found"};

        return resultSet.next();
    }
}