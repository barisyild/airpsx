package airpsx.service.task;

import haxe.io.Bytes;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import hx.well.http.RequestStatic.request;
import hx.well.validator.ValidatorRule;

class TaskCreateService extends AbstractService {
    public function validator():Bool {
        return request().validate([
            "name" => [ValidatorRule.Required, ValidatorRule.String]
        ]);
    }

    public function execute(request:Request):AbstractResponse {
        var name:String = request.input("name", "New Task");
        // TODO: Check String

        var connection = DBStatic.connection(DatabaseType.TASK);
        var id:Int = connection.insert('INSERT INTO tasks (name) VALUES (?)', name);

        var resultSet = DBStatic.connection(DatabaseType.TASK).query('SELECT * FROM tasks WHERE id = ?', id);
        if(!resultSet.hasNext())
            return {"message": "Task not found"};

        return resultSet.next();
    }
}