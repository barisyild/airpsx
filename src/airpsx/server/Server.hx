package airpsx.server;

import sys.net.Host;
import hx.concurrent.executor.Executor;
import sys.net.Socket;
import hx.well.server.AbstractServer;
import airpsx.Config;
using StringTools;

class Server extends AbstractServer {


    public function new() {
        super();
        Config.init();
    }

    public function host():Host {
        return new Host("0.0.0.0");
    }

    public function port():Int {
        return Config.HTTP_PORT;
    }

    public override function executor():Executor {
        return AirPSX.executor = Executor.create(3);
    }

    public override function socket():Socket {
        return AirPSX.socket = new Socket();
    }
}
