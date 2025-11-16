package hx.well.handler.application;

#if orbis
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using airpsx.tools.StringTools;
using airpsx.tools.ResultSetTools;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import hx.well.http.ResponseStatic.abort;

class ApplicationListHandler extends AbstractHandler {

    public function execute(request:Request):AbstractResponse {

        #if prospero
        return DBStatic.connection(DatabaseType.APP).query("SELECT titleId, titleName, CAST(size AS TEXT) AS size, installTime FROM tbl_contentinfo");
        #else
        var tableNameResultSet = DBStatic.connection(DatabaseType.APP).query("SELECT name FROM sqlite_master WHERE type='table' AND name LIKE 'tbl_appbrowse_%'");
        if(!tableNameResultSet.hasNext())
            abort(500); // tableNameResultSet not found

        var tableName:String = tableNameResultSet.getResult(0);
        return DBStatic.connection(DatabaseType.APP).query('SELECT titleId, titleName, CAST(contentSize AS TEXT) AS size, installDate as installTime FROM ${tableName} WHERE folderInfo = null');
        #end
    }
}
#end