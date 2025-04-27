package airpsx.service.pkg;

import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import cpp.lib.LibSceAppInstUtil;
import haxe.Int64;
using StringTools;
import hx.well.http.ResponseStatic.response;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import uuid.Uuid;
import airpsx.pkg.PackageVo;
import airpsx.command.ServePackageCommand;
import sys.io.File;
import sys.io.FileInput;
using airpsx.tools.OutputTools;

// TODO: Handle sockets with better way
class UploadPackageService extends AbstractService {
    /**
     * Reads data from the input stream until the HTTP header delimiter '\r\n\r\n' is found.
     * @param input The input stream to read from.
     * @return The data read up to the delimiter.
     */
    private function readUntilDelimiter(input:haxe.io.Input):String {
        var buffer = new StringBuf();
        var lastFourChars = "";
        
        try {
            while (true) {
                var char = String.fromCharCode(input.readByte());
                buffer.add(char);
                
                // Keep track of the last 4 characters
                lastFourChars += char;
                if (lastFourChars.length > 4) {
                    lastFourChars = lastFourChars.substr(lastFourChars.length - 4);
                }
                
                // Check if we've found the delimiter
                if (lastFourChars == "\r\n\r\n") {
                    break;
                }
            }
        } catch (e:Dynamic) {
            trace("Error reading from input: " + e);
        }
        
        return buffer.toString();
    }
    
    public function execute(request:Request):AbstractResponse {

        var acquired = ServePackageCommand.packageMutex.tryAcquire();
        if(!acquired) {
            return response().asJson({
                status: "error",
                message: "Server is busy"
            });
        }

        try {
            if(ServePackageCommand.packageVo != null) {
                ServePackageCommand.packageVo.dispose();
                ServePackageCommand.packageVo = null;
            }
        } catch (e) {
            ServePackageCommand.packageMutex.release();
            throw e;
        }
        ServePackageCommand.packageMutex.release();

        // http protocol shit
        trace(readUntilDelimiter(request.socket.input));

        var fileSize = Int64.parseString(request.query("size"));
        var predataOffset = Int64.parseString(request.query("offset"));

        // Create serve package session key
        var sessionKey:String = Uuid.nanoId(32);
        var packageVo:PackageVo = new PackageVo();
        packageVo.sessionKey = sessionKey;
        packageVo.sourceSocket = request.socket;
        packageVo.fileSize = fileSize;
        packageVo.predataOffset = predataOffset;

        // Predata available
        if(predataOffset != 0) {
            var preDataSize:Int = cast fileSize - predataOffset;

            var file = File.write(packageVo.predataFilePath, true);
            file.writeInputSize(request.socket.input, preDataSize);
            file.close();
        }

        // Read first 65536 bytes of the body
        packageVo.metadata = request.socket.input.read(65536);

        var titleId:String = null;
        if(predataOffset != 0) {
            var fileInput:FileInput = File.read(packageVo.predataFilePath);
            fileInput.seek(0x47, sys.io.FileSeek.SeekBegin);
            titleId = fileInput.readString(9);
            fileInput.close();
        }else{
            titleId = packageVo.metadata.getString(0x47, 9);
        }
        trace("Title ID: " + titleId);

        // Reset installation progress if the title is not already installed
        var contentStatusResultSet = DBStatic.connection(DatabaseType.APP).query("SELECT contentStatus FROM tbl_contentinfo WHERE titleId = ? LIMIT 1", titleId);
        if(contentStatusResultSet.length == 1) {
            var contentStatus = contentStatusResultSet.next().contentStatus;
            if(contentStatus != 0) {
                LibSceAppInstUtil.appInstUtilAppUnInstall(titleId);
            }
        }


        // Initialize serve package session
        ServePackageCommand.packageVo = packageVo;

        // Start installation
        LibSceAppInstUtil.appInstUtilInstallByPackage('http://localhost:1214/api/package/${sessionKey}.pkg', titleId);

        // Manage the socket manually without closing it
        return response().asManual();
    }
}