package protocols.http.services.task;

import sys.db.Sqlite;
import sys.net.Socket;
import utils.RuleScriptUtils;
import haxe.Exception;
import protocols.http.services.AbstractHttpService;
import protocols.http.HTTPRequest;


class TaskUpdateService extends AbstractHttpService {
    private static var types:Map<String, Dynamic> = [
        "id" => Int,
        "name" => String,
        "script" => String,
        "status" => Int,
        "frequency" => Int,
        "logs" => Bool,
        "enabled" => Bool
    ];

    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var jsonData:{id:Int, name:String, script:String, status:Int, frequency:Int, logs:Bool, enabled:Bool} = parseJson(request, types);

        trace(jsonData);

        var id:Int = jsonData.id;
        var db = Sqlite.open(Config.TASK_DB_PATH);
        var resultSet = db.request('SELECT id FROM tasks WHERE id = ${id}');
        if(!resultSet.hasNext())
        {
            db.close();
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

        db.request('UPDATE tasks SET ${updateQuery} WHERE id = ${id}');

        var resultSet = db.request('SELECT ${selectQuery} FROM tasks WHERE id = ${id}');
        if(!resultSet.hasNext())
        {
            db.close();
            return {"message": "Task not found"};
        }

        var result = resultSet.next();
        db.close();
        return result;
    }
}