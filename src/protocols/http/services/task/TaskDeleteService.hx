package protocols.http.services.task;
import sys.db.Sqlite;
import sys.net.Socket;
import protocols.http.HTTPRequest;
class TaskDeleteService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var jsonData:Dynamic = haxe.Json.parse(request.bodyBytes.toString());
        var id:Int = Std.parseInt(jsonData.id);

        var db = Sqlite.open(Config.TASK_DB_PATH);
        db.request('DELETE FROM tasks WHERE id = ${id};');

        return {success : true};
    }
}