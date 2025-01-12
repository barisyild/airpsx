package protocols.http.services.profile;
import haxe.io.Path;
import protocols.http.services.filesystem.AbstractHttpFileStreamService;
import sys.FileSystem;
import protocols.http.HTTPRequest;
using StringTools;

// WIP
class ProfileImageService extends AbstractHttpFileStreamService {
    public function filePath(request:HTTPRequest):String {
        var profileId:String = request.path.replace("/api/profile/image/", "");
        var profileImagePath:String = '${basePath()}/0x${profileId.toUpperCase()}/avatar.png';
        if(!FileSystem.exists(profileImagePath))
            return defaultIconPath();

        return profileImagePath;
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
        return "/system_data/priv/cache/profile";
    }
}