package airpsx.service.application;

#if orbis
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using airpsx.tools.StringTools;
using airpsx.tools.ResultSetTools;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;

class ApplicationListService extends AbstractService {

    public function execute(request:Request):AbstractResponse {

        return DBStatic.connection(DatabaseType.APP).query("SELECT titleId, titleName, CAST(size AS TEXT) AS size, installTime FROM tbl_contentinfo");
    }
}
#end