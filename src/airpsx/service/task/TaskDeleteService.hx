package airpsx.service.task;
import sys.db.Sqlite;
import sys.net.Socket;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import type.DatabaseType;
import hx.well.facades.DBStatic;
class TaskDeleteService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var jsonData:Dynamic = haxe.Json.parse(request.bodyBytes.toString());
        var id:Int = Std.parseInt(jsonData.id);
        DBStatic.connection(DatabaseType.TASK).query('DELETE FROM tasks WHERE id = ?', id);

        return {success : true};
    }
}