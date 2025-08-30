package hx.well.config;
import hx.well.server.instance.IInstance;
import hx.well.http.driver.socket.SocketInstance;
import airpsx.Const;

class InstanceConfig implements IConfig {
    public function new() {}

    #if !php
    public function get():Array<IInstance> {
        return [
            SocketInstance.builder()
                .setHost("0.0.0.0")
                .setPort(Const.HTTP_PORT)
                .setPoolSize(3)
                .build()
        ];
    }
    #end
}