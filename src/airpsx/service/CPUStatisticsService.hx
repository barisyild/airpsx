package airpsx.service;

import sys.db.ResultSet;
import hx.well.services.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using tools.ResultSetTools;
import hx.well.http.ResponseStatic.response;
import hx.well.database.Connection;
import hx.well.facades.DBStatic;
import type.DatabaseType;

// WIP
class CPUStatisticsService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        var resultSet:ResultSet = DBStatic.query("SELECT id, temperature, socSensorTemperature, frequency, titleID, timestamp FROM stats ORDER BY id DESC LIMIT 1000");

        var titleIDCache:Map<String, String> = new Map();

        return response().asResultSet(resultSet, null, (data) -> {
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
                    var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT titleName FROM tbl_contentinfo WHERE titleId = ?', titleID);
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
