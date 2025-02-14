package airpsx.service.task;

import sys.db.Sqlite;
import sys.net.Socket;
import utils.RuleScriptUtils;
import haxe.Exception;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import type.DatabaseType;


class TaskUpdateService extends AbstractService {
    private static var types:Map<String, Dynamic> = [
        "id" => Int,
        "name" => String,
        "script" => String,
        "status" => Int,
        "frequency" => Int,
        "logs" => Bool,
        "enabled" => Bool
    ];

    public function execute(request:Request):AbstractResponse {
        /*var jsonData:{id:Int, name:String, script:String, status:Int, frequency:Int, logs:Bool, enabled:Bool} = parseJson(request, types);*/

        var jsonData:{id:Int, name:String, script:String, status:Int, frequency:Int, logs:Bool, enabled:Bool} = haxe.Json.parse(request.bodyBytes.toString());

        trace(jsonData);

        var db = DBStatic.connection(DatabaseType.TASK);
        var id:Int = jsonData.id;
        var resultSet = db.query('SELECT id FROM tasks WHERE id = ?', id);
        if(!resultSet.hasNext())
        {
            return {error: "Task not found"};
        }

        // Check Script
        var script:String = jsonData.script;
        if(script != null && script != "")
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

        var name:String = jsonData.name;
        if(name == "")
        {
            return {error: 'name cannot be empty.'};
        }

        var i:Int = 0;
        var updateQuery:String = "";
        var selectQuery:String = "";
        for(key in types.keys())
        {
            var value:Dynamic = Reflect.field(jsonData, key);
            if(value == null)
                continue;

            value = Std.isOfType(value, String) ? db.quote(value) : value;
            updateQuery += '${i != 0 ? ", " : ""} ${key} = ${value}';
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