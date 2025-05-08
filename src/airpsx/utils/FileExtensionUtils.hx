package airpsx.utils;
class FileExtensionUtils {
    public static function resolveContentType(extension:String) {
        return switch (extension) {
            case "mp4":
                "video/mp4";
            case "webm":
                "video/webm";
            case "mp3":
                "audio/mpeg";
            case "flac":
                "audio/flac";
            case "png":
                "image/png";
            case "jpg" | "jpeg":
                "image/jpeg";
            case "jxr":
                "image/vnd.ms-photo";
            case "gif":
                "image/gif";
            case "webp":
                "image/webp";
            case "svg":
                "image/svg+xml";
            case "zip":
                "application/zip";
            case "7z":
                "application/x-7z-compressed";
            case "rar":
                "application/x-rar-compressed";
            case "tar":
                "application/x-tar";
            case "gz":
                "application/gzip";
            default:
                'application/octet-stream';
        }
    }
}
