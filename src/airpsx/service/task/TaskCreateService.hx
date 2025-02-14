package airpsx.service.task;
import sys.net.Socket;
import sys.db.Sqlite;
import haxe.io.Bytes;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import hx.well.facades.DBStatic;
import type.DatabaseType;

class TaskCreateService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var jsonData:Dynamic = haxe.Json.parse(request.bodyBytes.toString());
        var name:String = jsonData.name;
        // TODO: Check String

        var connection = DBStatic.connection(DatabaseType.TASK);
        var id:Int = connection.insert('INSERT INTO tasks (name) VALUES (?)', name);

        // Little hack
        trace('id => ${id}');
        request.bodyBytes = Bytes.ofString(haxe.Json.stringify({id: id}));
        return TaskDetailService.instance.execute(request);
    }
}