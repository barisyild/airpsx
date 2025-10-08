package hx.well.handler;

import hx.well.handler.filesystem.AbstractHttpFileStreamHandler;
import hx.well.http.Request;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
using StringTools;

// WIP
class TitleImageHandler extends AbstractHttpFileStreamHandler {
    public function filePath(request:Request):String {
        var titleId:String = request.route("titleId");
        var iconPath = defaultIconPath();
        var regex = new EReg("^[A-Z]{4}[0-9]{5}$", "");
        if(!regex.match(titleId))
            return iconPath;

        #if prospero
        var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT icon0Info FROM tbl_contentinfo WHERE titleId = ?', titleId);
        #else
        var resultSet = DBStatic.connection(DatabaseType.APP).query('SELECT val || "/icon0.png" as icon0Info FROM tbl_appinfo WHERE titleId = ? AND key = "_metadata_path"', titleId);
        #end
        if(!resultSet.hasNext())
            return iconPath;

        try
        {
            resultSet.next();
            iconPath = resultSet.getResult(0);
        } catch (e)
        {
            return iconPath;
        }

        var questionMarkIndex = iconPath.indexOf("?");
        if(questionMarkIndex != -1)
            iconPath = iconPath.substring(0, questionMarkIndex);
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