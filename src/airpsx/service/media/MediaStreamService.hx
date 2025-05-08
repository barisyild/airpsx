package airpsx.service.media;
import airpsx.service.filesystem.AbstractHttpFileStreamService;
import hx.well.http.Request;
import sys.io.FileInput;
import sys.io.File;
import sys.io.FileSeek;
import airpsx.utils.FileExtensionUtils;
class MediaStreamService extends AbstractHttpFileStreamService {
    public function new() {
        super();
    }

    public override function fileName(request:Request):String {
        var path:String = request.route("path");
        var fileName:String = path.substring(0, path.lastIndexOf("."));
        var extension:String = path.substring(path.lastIndexOf(".") + 1);

        trace('fileName: ${fileName}');
        var datFileName = "";
        var datFile:FileInput = File.read('/user/av_contents/${fileName}.dat', true);
        try {
            datFile.seek(0x44, FileSeek.SeekBegin);
            while (true) {
                var byte:Int = datFile.readByte();
                if(byte == 0x00)
                    break;

                datFileName += String.fromCharCode(byte);
            }
            datFile.close();
        } catch (e) {
            datFile.close();
        }

        trace(datFileName);

        if(datFileName == "")
            return null;

        return '${datFileName}.${extension}';
    }

    public function filePath(request:Request):String {
        return '/user/av_contents/${request.route("path")}';
    }

    public function basePath():Null<String> {
        return "/user/av_contents/";
    }

    public function bufferSize():Int {
        return 1024 * 10;
    }

    public function contentType(request:Request):Null<String> {
        var extension = request.path.substring(request.path.lastIndexOf(".") + 1);
        return FileExtensionUtils.resolveContentType(extension);
    }

    public function isDownloadRequest(request:Request):Bool {
        trace(request.query("download", "false"));
        return request.query("download", "false") == "true";
    }
}
