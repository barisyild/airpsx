package hx.well.handler.task;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import hx.well.validator.ValidatorRule;
import hx.well.http.RequestStatic.request;

class TaskDetailHandler extends AbstractHandler {
    public static var instance:TaskDetailHandler;

    public override function validate():Bool {
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