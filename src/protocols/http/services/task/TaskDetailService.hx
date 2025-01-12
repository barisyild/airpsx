package protocols.http.services.task;
import sys.net.Socket;
import protocols.http.HTTPRequest;
class TaskDetailService extends AbstractHttpService {
    public static var instance:TaskDetailService;

    public function new() {
        super();
        instance = this;
    }

    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var jsonData:Dynamic = haxe.Json.parse(request.bodyBytes.toString());
        var id:Int = Std.parseInt(jsonData.id);

        var db = sys.db.Sqlite.open(Config.TASK_DB_PATH);
        var resultSet = db.request('SELECT * FROM tasks WHERE id = ${id}');
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