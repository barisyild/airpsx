package hx.well.handler.task;

import haxe.io.Bytes;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import hx.well.http.RequestStatic.request;
import hx.well.validator.ValidatorRule;
import airpsx.type.ScriptType;

class TaskCreateHandler extends AbstractHandler {
    public override function validate():Bool {
        return request().validate([
            "name" => [ValidatorRule.Required, ValidatorRule.String]
        ]);
    }

    public function execute(request:Request):AbstractResponse {
        var name:String = request.input("name", "New Task");
        var type:ScriptType = request.input("type", ScriptType.RULESCRIPT);
        // TODO: Check String

        var connection = DBStatic.connection(DatabaseType.TASK);
        var id:Int = connection.insert('INSERT INTO tasks (name, type) VALUES (?, ?)', name, type);

        var resultSet = DBStatic.connection(DatabaseType.TASK).query('SELECT * FROM tasks WHERE id = ?', id);
        if(!resultSet.hasNext())
            return {"message": "Task not found"};

        return resultSet.next();
    }
}