package protocols.http.services.task;
import sys.net.Socket;
import sys.db.Sqlite;
import haxe.io.Bytes;
import protocols.http.HTTPRequest;

class TaskCreateService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var jsonData:Dynamic = haxe.Json.parse(request.bodyBytes.toString());
        var name:String = jsonData.name;

        var db = Sqlite.open(Config.TASK_DB_PATH);
        db.request('INSERT INTO tasks (name) VALUES (${db.quote(name)});');
        var id:Int = db.lastInsertId();
        db.close();

        // Little hack
        trace('id => ${id}');
        request.bodyBytes = Bytes.ofString(haxe.Json.stringify({id: id}));
        return TaskDetailService.instance.execute(request, socket);
    }
}