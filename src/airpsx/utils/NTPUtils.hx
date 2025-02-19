package airpsx.utils;

import haxe.io.Bytes;
import sys.net.Address;
import sys.net.Host;
import sys.net.UdpSocket;
import haxe.io.BytesInput;

class NTPUtils {
    public static function readBytes():Bytes {
        var host = "pool.ntp.org";
        var port = 123;

        var address:Address = new Address();
        address.host = new Host(host).ip;
        address.port = port;

        var socket = new UdpSocket();
        socket.connect(address.getHost(), port);

        var packet = Bytes.alloc(48);
        packet.set(0, 0xE3);

        socket.output.write(packet);

        var bytes = Bytes.alloc(48);
        socket.input.readBytes(bytes, 0, 48);

        return bytes;
    }

    public static function readTime():{seconds:Float, fraction:Float} {
        var bytes = readBytes();
        var bytesInput = new BytesInput(bytes, 40);
        bytesInput.bigEndian = true;

        var rawSeconds:Int = bytesInput.readInt32();
        var seconds:Float = rawSeconds < 0 ? rawSeconds + 4294967296 : rawSeconds;
        seconds -= 2208988800;

        var fraction = bytesInput.readInt32() / 4294967296.0;
        return {seconds: seconds, fraction: fraction};
    }
}
