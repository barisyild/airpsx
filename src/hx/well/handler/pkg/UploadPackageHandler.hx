package hx.well.handler.pkg;

import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using StringTools;
import hx.well.http.ResponseBuilder;
import airpsx.pkg.PackageChunkVo;
using airpsx.tools.OutputTools;
using airpsx.tools.InputTools;
import haxe.io.PartialInput;
import hx.well.http.encoding.EmptyEncodingOptions;
import airpsx.pkg.PackageVo;

class UploadPackageHandler extends AbstractHandler {
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
        trace("UploadPackageHandler: Handling package chunk upload.");

        // http protocol shit
        trace(readUntilDelimiter(request.context.input));

        // Create serve package session key
        var sessionKey:String = request.query("sessionKey");
        var chunkKey:String = request.query("chunkKey");
        trace('UploadPackageHandler: sessionKey=${sessionKey}, chunkKey=${chunkKey}');

        var packageVo:PackageVo = PackageVo.current;
        if(packageVo == null || packageVo.sessionKey != sessionKey) {
            trace("UploadPackageHandler: Invalid session key.");
            return ResponseBuilder.asJson({
                status: "error",
                message: "Invalid session key."
            }).status(404);
        }

        // Get chunk from key
        var chunk:Null<PackageChunkVo> = packageVo.chunks.filter(chunk -> chunk.key == chunkKey)[0];
        if(chunk == null) {
            trace("UploadPackageHandler: Invalid chunk key.");
            return ResponseBuilder.asJson({
                status: "error",
                message: "Invalid chunk key."
            }).status(404);
        }

        chunk.sourceContext = request.context;

        // Write data to chunk
        trace("Write data to chunk: " + chunk.start + " - " + chunk.end + " - " + chunk.fileSize);
        var response = ResponseBuilder
            .asInput(new PartialInput(request.context.input.asUncloseable(), chunk.fileSize), chunk.fileSize)
            .status(206)
            .header("Content-Range", 'bytes ${chunk.start}-${chunk.end}/${packageVo.fileSize}')
            .header("Content-Type", "application/octet-stream")
            .header("Accept-Ranges", "bytes");
        response.encodingOptions = new EmptyEncodingOptions();

        trace("UploadPackageHandler: Chunk upload handled successfully.");
        try {
            chunk.context.writeResponse(response);
        } catch (e) {
            chunk.context.close();
        }

        packageVo.chunks.remove(chunk);
        trace("UploadPackageHandler: Sent response for chunk upload.");

        if(packageVo.chunks.length == 0) {
            var attempts = 0;
            while (attempts < 500 && packageVo.chunks.length == 0) {
                Sys.sleep(0.1);
                attempts++;
            }

            if(packageVo.chunks.length == 0) {
                // TODO: Delete chunks
                trace("Chunks request error.");
            }
        }

        var chunks:Array<PackageChunkVo> = packageVo.chunks.toArray();
        return ResponseBuilder.asJson({
            status: "success",
            sessionKey: sessionKey,
            chunks: chunks.map(packageChunkVo -> {key: packageChunkVo.key, start: packageChunkVo.start, end: packageChunkVo.end, createdAt: packageChunkVo.createdAt})
        });
    }
}