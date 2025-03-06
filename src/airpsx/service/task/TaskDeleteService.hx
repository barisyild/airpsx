package airpsx.service.task;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import airpsx.type.DatabaseType;
import hx.well.facades.DBStatic;
import hx.well.http.RequestStatic.request;
import hx.well.validator.ValidatorRule;

class TaskDeleteService extends AbstractService {
    public function validator():Bool {
        return request().validate([
            "id" => [ValidatorRule.Required, ValidatorRule.Int]
        ]);
    }

    public function execute(request:Request):AbstractResponse {
        var id:Int = request.input("id");
        DBStatic.connection(DatabaseType.TASK).query('DELETE FROM tasks WHERE id = ?', id);

        return {success : true};
    }
}