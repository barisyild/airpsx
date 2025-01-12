package protocols.http;

import haxe.io.Input;
import haxe.io.Bytes;
import protocols.http.HTTPRequest;
using StringTools;

class HTTPRequest {
    public var method: String;
    public var path: String;
    public var version: String;
    public var headers: Map<String, String> = new Map<String, String>();
    public var requestBytes: Bytes;
    public var bodyBytes: Bytes;
    //public var body: String ;

    private static var httpRequestEnd = [0x0D, 0x0A, 0x0D, 0x0A];

    public function new() {

    }

    // Make a max length limit for the request
    public static function parseInput(input:Input):HTTPRequest
    {
        var requestBytes:Bytes = parseInputProtocol(input);

        var request:HTTPRequest = HTTPRequest.parseRequest(requestBytes.toString());
        request.requestBytes = requestBytes;


        return request;
    }

    public static function parseBody(input:Input, request:HTTPRequest):Void
    {
        if(request.headers.exists("Content-Length") && request.headers.get("Content-Length") != "0")
        {
            var contentLength = Std.parseInt(request.headers.get("Content-Length"));
            var bodyBytes:Bytes = parseInputBody(input, contentLength);
            request.bodyBytes = bodyBytes;
        }else{
            request.bodyBytes = Bytes.alloc(0);
        }
    }

    private static function parseInputProtocol(input:Input):Bytes
    {
        var buffer:Array<cpp.UInt8> = new Array<cpp.UInt8>();
        var index:Int = 0;
        while (true)
        {
            var found:Bool = false;
            buffer[index] = input.readByte();
            if (index >= 4)
            {
                found = true;
                for(i in 0...4)
                {
                    if(buffer[index - 3 + i] != httpRequestEnd[i])
                    {
                        found = false;
                        break;
                    }
                }
            }
            index++;

            if(found)
                break;
        }

        buffer.resize(buffer.length - httpRequestEnd.length);
        return Bytes.ofData(buffer);
    }

    private static function parseInputBody(input:Input, size:Int):Bytes
    {
        return input.read(size);
    }

    public static function parseRequest(rawRequest: String): HTTPRequest {
        var lines = rawRequest.split("\r\n");
        var requestLine = lines[0].split(" ");
        var method = requestLine[0];
        var path = requestLine[1].urlDecode();
        var version = requestLine[2];
        var headers = new Map<String, String>();
        for (i in 1...lines.length) {
            var header = lines[i].split(": ");
            if (header.length == 2) {
                headers.set(header[0], header[1]);
            }
        }
        // Parse body
        var body = "";
        if (headers.exists("Content-Length")) {
            var contentLength = Std.parseInt(headers.get("Content-Length"));
            var bodyStart = rawRequest.indexOf(requestLine[3]) + 4;
            body = rawRequest.substr(bodyStart, contentLength);
        }

        var request:HTTPRequest = new HTTPRequest();
        request.method = method;
        request.path = path;
        request.version = version;
        request.headers = headers;
        return request;
    }

    public static function isBodyAvailable(request:HTTPRequest):Bool {
        return request.headers.exists("Content-Length");
    }
}