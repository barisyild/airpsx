package hx.well.handler.script.remote;

#if orbis
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import sys.FileSystem;
import sys.io.File;
import cpp.lib.Systemctl;
import sys.io.FileOutput;
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
import uuid.Uuid;
import haxe.Exception;
import sys.db.ResultSet;
import haxe.io.Output;
import haxe.Int32;
import haxe.io.Bytes;
import com.hurlant.math.BigInteger;
import com.hurlant.crypto.tls.TLSError;
import com.hurlant.util.ByteArray;
import com.hurlant.crypto.rsa.RSAKey;
import com.hurlant.util.der.PEM;
import sys.io.FileInput;
import haxe.CallStack;
import hx.well.http.ResponseBuilder;
import airpsx.Const;

class RemoteScriptListHandler extends AbstractHandler {
    public function new() {
        super();
    }

    public function execute(request:Request):AbstractResponse {
        var isLatestDatabase:Bool = false;
        var search:String = request.input("search");

        // Download database if search is null
        if(search == null) {
            try {
                downloadDB();
                isLatestDatabase = true;
            } catch (e:Exception) {
                trace(e.message, CallStack.toString(e.stack));
            }
        }

        if(!FileSystem.exists(Const.SCRIPT_DB_PATH)) {
            return {success: false, message: "Problem occurred while downloading database"};
        }

        var parameters:Array<Dynamic> = [Systemctl.kernelSdkVersion, Systemctl.kernelSdkVersion];
        var query:String = 'SELECT key, name, description, scriptHash, type, authorName, authorSrc FROM scripts WHERE minFirmware <= ? AND maxFirmware >= ?';

        // 0.00 is debug build or github actions artifacts
        if(Const.VERSION != "0.00") {
            query += ' and version <= ?';
            parameters.push(Const.VERSION);
        }

        if(search != null) {
            query += " and name LIKE ? || '%'";
            parameters.push(search);

            query +=  " ORDER BY CASE WHEN name LIKE ? || '%' THEN 0 ELSE 1 END, name;";
            parameters.push(search);
        }

        var resultSet:ResultSet = DBStatic.connection(DatabaseType.SCRIPT_DB).query(query, ...parameters);

        // [{"version":"0.15","authorSrc":"https://github.com/barisyild","type":"rulescript","name":"Clear Browser Cache","minFirmware":"00.00","hash":"794e3f6d63865e23317505d85d535c2b","authorName":"barisyild","key":"clearBrowserCache","maxFirmware":"99.99"}]
        return ResponseBuilder.asResultSet(resultSet, null, (data) -> {
            var scriptHash:String = data.scriptHash;
            var scriptFile:String = '${Const.SCRIPT_PATH}/${scriptHash}';
            data.hasCache = FileSystem.exists(scriptFile);
        });
    }

    private function downloadDB(?url:String):Void {
        if(!FileSystem.exists('${Const.TEMP_PATH}/scripts'))
            FileSystem.createDirectory('${Const.TEMP_PATH}/scripts');

        var randomFilePath:String = '${Const.TEMP_PATH}/scripts/${Uuid.v4()}.db';
        var fileOutput:FileOutput = File.write(randomFilePath, true);

        var console:String = "ps5";
        var http = new sys.Http('https://airpsx.com/db/${console}.db.signed');
        http.onStatus = status -> {
            if(status != 200)
                throw "HTTP error: " + status;
        };

        http.onError = error -> {

            // try to close file
            try {
                fileOutput.close();
            } catch (e) {

            }
            throw error;
        };

        http.customRequest(false, fileOutput, null, "GET");

        var publicKey:RSAKey = PEM.readRSAPublicKey("-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAspAcOlJD+Ttf4r4VCs79p2abcxCU3jwseekVEzjYLrQS+KX6f9cw
/Wq+P4xDJLY6zsTij9nbSEtyt1LpwdgaYVU5kPp6a426X0JO1yC2FdWV/OU0sP7d
WIvPDtcEmwfqqwpcVXuCBD5iQtEcdVtmL0R92xBcJ+EM74cdUCWhyKasEhmlMB+8
jZu+rg+eu2YUGCwuCNWdKZ4jcuv7ZNoqxghvvpStnGkv0lNPTW1y0gRRbgoMbTuQ
MiYln8ahqvcUAmoRhKhTsfRapzowTBkfMPszzhivlG6rnMpCSFvPfgsVj5xAktYG
DGFoIV182km9IcwvAyOzPm5GX+s4m99zHwIDAQAB
-----END RSA PUBLIC KEY-----
");

        var newRandomFilePath:String = '${Const.TEMP_PATH}/scripts/${Uuid.v4()}.db';
        var fileInput:FileInput = File.read(randomFilePath, true);
        var fileSize:Int32 = FileSystem.stat(randomFilePath).size;
        var fileOutput:FileOutput = File.write(newRandomFilePath, true);

        bufferedVerify(publicKey, fileInput, fileOutput, fileSize);
        fileInput.close();
        fileOutput.close();

        FileSystem.deleteFile(randomFilePath);

        if(FileSystem.exists(Const.SCRIPT_DB_PATH))
            FileSystem.deleteFile(Const.SCRIPT_DB_PATH);

        // Rename new database
        FileSystem.rename(newRandomFilePath, Const.SCRIPT_DB_PATH);
    }

    public function bufferedVerify(key:RSAKey, src:FileInput, dst:Output, length:Int32, pad:BigInteger -> Int32 -> Int32 -> ByteArray = null):Void {
        var blockSize = key.getBlockSize();
        var buffer = Bytes.alloc(blockSize);
        var end = src.tell() + length;

        while (src.tell() < end) {
            // Read the next block into the buffer
            var bytesRead = src.readBytes(buffer, 0, blockSize);
            if (bytesRead == 0) break;

            var block = new BigInteger(ByteArray.fromBytes(buffer), bytesRead, true); // Convert block to BigInteger
            var chunk = @:privateAccess key.doPublic(block); // Perform RSA public operation (decryption for verification)

            var unpaddedBlock = @:privateAccess key.pkcs1unpad(chunk, blockSize, 0x01); // PKCS#1 unpadding

            if (unpaddedBlock == null) {
                throw new TLSError("Verification error - padding function returned null!", TLSError.decode_error);
            }

            // Write the unpadded block to the destination Output stream
            dst.write(unpaddedBlock);
        }
    }
}
#end