package airpsx.service.task;

import sys.db.Sqlite;
import sys.net.Socket;
import airpsx.utils.RuleScriptUtils;
import haxe.Exception;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import hx.well.http.RequestStatic.request;
import hx.well.validator.ValidatorRule;
import airpsx.type.ScriptType;

class TaskUpdateService extends AbstractService {
    private static var types:Array<String> = [
        "id",
        "name",
        "script",
        "status",
        "frequency",
        "logs",
        "type",
        "enabled",
    ];

    public override function validate():Bool {
        return request().validate([
            "id" => [ValidatorRule.Required, ValidatorRule.Int],
            "name" => [ValidatorRule.String],
            "script" => [ValidatorRule.String],
            "status" => [ValidatorRule.Int],
            "frequency" => [ValidatorRule.Int],
            "logs" => [ValidatorRule.Bool],
            "type" => [ValidatorRule.String],
            "enabled" => [ValidatorRule.Bool]
        ]);
    }

    public function execute(request:Request):AbstractResponse {
        /*var jsonData:{id:Int, name:String, script:String, status:Int, frequency:Int, logs:Bool, enabled:Bool} = parseJson(request, types);*/

        var db = DBStatic.connection(DatabaseType.TASK);
        var id:Int = request.input("id");
        var resultSet = db.query('SELECT id FROM tasks WHERE id = ?', id);
        if(!resultSet.hasNext())
        {
            return {error: "Task not found"};
        }

        // Check Script
        var script:String = request.input("script");
        var type:ScriptType = request.input("type", resultSet.next().type);
        if(type == ScriptType.RULESCRIPT && script != null && script != "")
        {
            try
            {
                RuleScriptUtils.parse(script);
            } catch (e:Exception)
            {
                trace(Type.getClass(e));

                return {error: '${e.toString()} ${e.stack.toString()}'};
            }
        }

        var name:String = request.input("name");
        if(name == "")
        {
            return {error: 'name cannot be empty.'};
        }

        var i:Int = 0;
        var updateQuery:String = "";
        var selectQuery:String = "";
        for(key in types)
        {
            var value:Dynamic = request.input(key);
            if(value == null)
                continue;

            updateQuery += '${i != 0 ? ", " : ""} ${key} = ${db.quote(value)}';
            selectQuery += '${i != 0 ? ", " : ""} ${key}';

            i++;
        }

        db.query('UPDATE tasks SET ${updateQuery} WHERE id = ?', id);

        var resultSet = db.query('SELECT ${selectQuery} FROM tasks WHERE id = ?', id);
        if(!resultSet.hasNext())
        {
            return {"message": "Task not found"};
        }

        return resultSet.next();
    }
}