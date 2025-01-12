package protocols.http;
import haxe.http.HttpStatus;
import haxe.io.Bytes;
class HttpResponse {
    public var statusCode: Int;
    public var status: String = "OK";
    public var headers: Map<String, String> = new Map<String, String>();
    public var body(get, set): String;
    public var bodyBytes:Bytes = Bytes.alloc(0);

    public function new() {

    }

    public function get_body():String
    {
        return bodyBytes.toString();
    }

    public function set_body(value:String):String
    {
        bodyBytes = Bytes.ofString(value);
        return body;
    }

    public function toString(): String {
        var response: String = "HTTP/1.1 " + statusCode + " " + status + "\r\n";
        for (header in headers.keys()) {
            // Ignore content length header
            if(headers.exists("Content-Length") && header == "Content-Length")
                continue;

            response += header + ": " + headers.get(header) + "\r\n";
        }
        response += 'Content-Length: ${body.length}\r\n';
        response += "\r\n";

        if(body != null)
        {
            response += body;
        }
        return response;
    }

    public function toBytes(): Bytes {
        var response: String = "HTTP/1.1 " + statusCode + "\r\n";
        for (header in headers.keys()) {
            // Ignore content length header
            if(headers.exists("Content-Length") && header == "Content-Length")
                continue;

            response += header + ": " + headers.get(header) + "\r\n";
        }
        response += 'Content-Length: ${bodyBytes.length}\r\n';
        response += "\r\n";

        var responseBytes = Bytes.alloc(response.length + bodyBytes.length);
        var responseStringBytes = Bytes.ofString(response);
        responseBytes.blit(0, responseStringBytes, 0, responseStringBytes.length);
        if(bodyBytes != null)
        {
            responseBytes.blit(response.length, bodyBytes, 0, bodyBytes.length);
        }
        return responseBytes;
    }
}
