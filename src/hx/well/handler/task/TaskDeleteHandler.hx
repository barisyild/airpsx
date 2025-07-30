package hx.well.handler.task;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import airpsx.type.DatabaseType;
import hx.well.facades.DBStatic;
import hx.well.http.RequestStatic.request;
import hx.well.validator.ValidatorRule;

class TaskDeleteHandler extends AbstractHandler {
    public override function validate():Bool {
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