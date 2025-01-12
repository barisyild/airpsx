package protocols.http.services;
import haxe.io.Path;
import protocols.http.services.filesystem.AbstractHttpFileStreamService;
import protocols.http.HTTPRequest;
using StringTools;

// WIP
class TitleImageService extends AbstractHttpFileStreamService {
    public function filePath(request:HTTPRequest):String {
        var titleId:String = request.path.replace("/api/title/image/", "");
        var iconPath = defaultIconPath();
        var regex = new EReg("^[A-Z]{4}[0-9]{5}$", "");
        if(!regex.match(titleId))
            return iconPath;

        var db = sys.db.Sqlite.open(Config.SYSTEM_APP_DB_PATH);
        var resultSet = db.request('SELECT icon0Info FROM tbl_contentinfo WHERE titleId = "${titleId}"');
        if(!resultSet.hasNext())
        {
            db.close();
            return iconPath;
        }

        var iconUrl:String = "";

        try
        {
            resultSet.next();
            iconUrl = resultSet.getResult(0);
        } catch (e)
        {
            db.close();
            return iconPath;
        }
        db.close();

        iconPath = iconUrl.substring(0, iconUrl.indexOf("?"));
        return iconPath;
    }

    private function defaultIconPath():String {
        return '/system_ex/rnps/apps/NPXS40144/appdb/NPXS40148/icon0.png';
    }

    public function bufferSize():Int {
        return 1024 * 10;
    }

    public function contentType(request:HTTPRequest):String {
        return "image/png";
    }

    public function isDownloadRequest(request:HTTPRequest):Bool
    {
        return false;
    }

    public function basePath():Null<String> {
        return null;
    }
}