package hx.well.handler.profile;

import hx.well.handler.filesystem.AbstractHttpFileStreamHandler;
import sys.FileSystem;
import hx.well.http.Request;
using StringTools;

// WIP
class ProfileImageHandler extends AbstractHttpFileStreamHandler {
    public function filePath(request:Request):String {
        var profileId:String = request.route("profileId");
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

    public function contentType(request:Request):String {
        return "image/png";
    }

    public function isDownloadRequest(request:Request):Bool
    {
        return false;
    }

    public function basePath():Null<String> {
        return "/system_data/priv/cache/profile";
    }
}