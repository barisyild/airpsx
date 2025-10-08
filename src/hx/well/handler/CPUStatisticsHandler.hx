package hx.well.handler;

import sys.db.ResultSet;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using airpsx.tools.ResultSetTools;
import hx.well.database.Connection;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import hx.well.http.ResponseBuilder;

// WIP
class CPUStatisticsHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var resultSet:ResultSet = DBStatic.query("SELECT id, temperature, socSensorTemperature, frequency, titleID, timestamp FROM stats ORDER BY id DESC LIMIT 1000");

        var titleIDCache:Map<String, String> = new Map();

        return ResponseBuilder.asResultSet(resultSet, null, (data) -> {
            var titleID:String = data.titleID;
            if(titleID == "")
                return;

            var titleName:String = null;

            if(titleIDCache.exists(titleID))
            {
                titleName = titleIDCache.get(titleID);
            }else{
                try
                {
                    #if prospero
                    var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT titleName FROM tbl_contentinfo WHERE titleId = ?', titleID);
                    #else
                    var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT val as titleName FROM tbl_appinfo WHERE titleId = ? AND key = "TITLE"', titleID);
                    #end
                    titleName = resultSet.hasNext() ? resultSet.getResult(0) : null;
                    titleIDCache.set(titleID, titleName);
                } catch (e)
                {
                    titleIDCache.set(titleID, "");
                }

                trace(titleName);
            }

            if(titleName != null)
            {
                data.titleName = titleName;
            }
        });
    }
}
