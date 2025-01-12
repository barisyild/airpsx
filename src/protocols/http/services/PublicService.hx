package protocols.http.services;

import haxe.io.Path;
import haxe.Exception;
import sys.FileSystem;
import protocols.http.services.filesystem.AbstractHttpFileStreamService;
import protocols.http.HTTPRequest;

using StringTools;

// WIP
class PublicService extends AbstractHttpFileStreamService {
    public function filePath(request:HTTPRequest):String {
        var requestPath = request.path;
        if(requestPath == "/")
            requestPath = "/index.html";

        var basePath:String = basePath();

        var path = Path.normalize(basePath + requestPath);
        if(!path.startsWith(basePath) || !FileSystem.exists(path))
            return basePath + "/index.html";

        return path;
    }

    public function basePath():Null<String> {
        return '${Config.DATA_PATH}/public/';
    }

    public function bufferSize():Int {
        return 1024 * 10;
    }

    public function contentType(request:HTTPRequest):String {
        var path = filePath(request);

        var fileExtension = path.substring(path.lastIndexOf(".") + 1);
        switch (fileExtension)
        {
            case "html":
                return "text/html";
            case "css":
                return "text/css";
            case "js":
                return "text/javascript";
            case "json":
                return "application/json";
            case "png":
                return "image/png";
            case "jpg" | "jpeg":
                return "image/jpeg";
            case "ico":
                return "image/x-icon";
            case "svg":
                return "image/svg+xml";
            case "ttf":
                return "font/ttf";
            case "woff":
                return "font/woff";
            case "woff2":
                return "font/woff2";
            case "eot":
                return "font/eot";
            case "otf":
                return "font/otf";
            case "mp3":
                return "audio/mpeg";
            case "wav":
                return "audio/wav";
            case "mp4":
                return "video/mp4";
            case "webm":
                return "video/webm";
            case "pdf":
                return "application/pdf";
            case "zip":
                return "application/zip";
            case "tar":
                return "application/x-tar";
            case "gz":
                return "application/gzip";
            case "bz2":
                return "application/x-bzip2";
            case "7z":
                return "application/x-7z-compressed";
            case "rar":
                return "application/x-rar-compressed";
            case "doc":
                return "application/msword";
            case "docx":
                return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            case "xls":
                return "application/vnd.ms-excel";
            default:
                return "application/octet-stream";
        }
    }

    public function isDownloadRequest(request:HTTPRequest):Bool
    {
        return false;
    }
}
