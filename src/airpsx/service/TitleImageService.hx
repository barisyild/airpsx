package airpsx.service;

import airpsx.service.filesystem.AbstractHttpFileStreamService;
import hx.well.http.Request;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
using StringTools;

// WIP
class TitleImageService extends AbstractHttpFileStreamService {
    public function filePath(request:Request):String {
        var titleId:String = request.route("titleId");
        var iconPath = defaultIconPath();
        var regex = new EReg("^[A-Z]{4}[0-9]{5}$", "");
        if(!regex.match(titleId))
            return iconPath;

        var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT icon0Info FROM tbl_contentinfo WHERE titleId = ?', titleId);
        if(!resultSet.hasNext())
            return iconPath;

        var iconUrl:String = "";

        try
        {
            resultSet.next();
            iconUrl = resultSet.getResult(0);
        } catch (e)
        {
            return iconPath;
        }

        iconPath = iconUrl.substring(0, iconUrl.indexOf("?"));
        return iconPath;
    }

    private function defaultIconPath():String {
        return '/system_ex/rnps/apps/NPXS40144/appdb/NPXS40148/icon0.png';
    }

    public function bufferSize():Int {
        return 1024 * 10;
    }

    public function contentType(request:Request):String {
        return "image/png";
    }

    public function isDownloadRequest(request:Request):Bool
    {
        return false;
    }

    public function basePath():Null<String> {
        return null;
    }
}