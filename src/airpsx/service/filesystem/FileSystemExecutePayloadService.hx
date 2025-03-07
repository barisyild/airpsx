package airpsx.service.filesystem;
import hx.well.service.AbstractService;
import hx.well.http.AbstractResponse;
import hx.well.http.Request;
import sys.net.Socket;
import sys.net.Host;
import sys.io.FileInput;
import sys.io.File;
import sys.FileSystem;
import hx.well.validator.ValidatorRule;
import hx.well.http.RequestStatic.request;
import haxe.io.Bytes;
import sys.io.FileSeek;

class FileSystemExecutePayloadService extends AbstractService {
    public override function validate():Bool {
        return request().validate([
            "path" => [ValidatorRule.Required, ValidatorRule.Custom("fileExists")]
        ]);
    }

    public function execute(request:Request):AbstractResponse {
        var filePath:String = request.input("path");
        if(!FileSystem.exists(filePath) || FileSystem.isDirectory(filePath))
            return {success: false, message: "File not found."};

        var file:FileInput = File.read(filePath, true);
        var magicBytes:Bytes;

        try {
            magicBytes = file.read(4);
        } catch (e) {
            file.close();
            return {success: false, message: "File is not valid."};
        }

        // Validate magic bytes
        if(magicBytes.compare(Bytes.ofData([0x7F, 0x45, 0x4C, 0x46])) != 0) {
            file.close();
            return {success: false, message: "Invalid file format."};
        }

        // Reset file pointer
        file.seek(0, FileSeek.SeekBegin);

        // Send elf file
        var socket:Socket = null;
        for(port in [9020, 9021, 9022]) {
            var tempSocket:Socket = new Socket();
            try {
                tempSocket.connect(new Host("127.0.0.1"), port);
                socket = tempSocket;
            } catch (e) {

            }
        }
        if(socket == null)
            return {success: false, message: "No running elf loader found."};

        try {
            socket.output.writeInput(file);
            socket.close();
            file.close();
        } catch (e) {
            file.close();
            throw e;
        }


        return {success: true};
    }
}
