package cpp.extern;

#if orbis
import cpp.Int32;

@:keep
@:include('libSceNetCtl.h')
extern class ExternLibSceNetCtl {
    @:native("sceNetCtlInit")
    public static function sceNetCtlInit():Int32;

    @:native("sceNetCtlTerm")
    public static function sceNetCtlTerm():Int32;

    @:native("sceNetCtlGetInfo")
    public static function sceNetCtlGetInfo(s:Int32, b:AbstractPointer<SceNetCtlInfoExtern>):Int32;
}


class SceNetCtlInfo {
    public var device:UInt32;
    public var mtu:UInt32;
    public var link:UInt32;
    public var ssid:String;
    public var wifi_security:UInt32;
    public var rssi_dbm:Int32;
    public var rssi_percentage:UInt8;
    public var channel:UInt8;
    public var ip_config:UInt32;
    public var dhcp_hostname:String;
    public var pppoe_auth_name:String;
    public var ip_address:String;
    public var netmask:String;
    public var default_route:String;
    public var primary_dns:String;
    public var secondary_dns:String;
    public var http_proxy_config:UInt32;
    public var http_proxy_server:String;
    public var http_proxy_port:UInt16;

    public function new():Void {

    }
}

@:native('SceNetCtlInfo')
@:structAccess
extern class SceNetCtlInfoExtern {
    public var device:UInt32;
    public var ether_addr:SceNetEtherAddrExtern;
    public var mtu:UInt32;
    public var link:UInt32;
    public var bssid:SceNetEtherAddrExtern;
    public var ssid:ConstCharStar;
    public var wifi_security:UInt32;
    public var rssi_dbm:Int32;
    public var rssi_percentage:UInt8;
    public var channel:UInt8;
    public var ip_config:UInt32;
    public var dhcp_hostname:ConstCharStar;
    public var pppoe_auth_name:ConstCharStar;
    public var ip_address:ConstCharStar;
    public var netmask:ConstCharStar;
    public var default_route:ConstCharStar;
    public var primary_dns:ConstCharStar;
    public var secondary_dns:ConstCharStar;
    public var http_proxy_config:UInt32;
    public var http_proxy_server:ConstCharStar;
    public var http_proxy_port:UInt16;

    public static inline function create():SceNetCtlInfoExtern {
        return untyped __cpp__('{}');
    }

    public inline function toObject():SceNetCtlInfo {
        var info = new SceNetCtlInfo();
        info.device = this.device;
        info.mtu = this.mtu;
        info.link = this.link;
        info.ssid = this.ssid;
        info.wifi_security = this.wifi_security;
        info.rssi_dbm = this.rssi_dbm;
        info.rssi_percentage = this.rssi_percentage;
        info.channel = this.channel;
        info.ip_config = this.ip_config;
        info.dhcp_hostname = this.dhcp_hostname;
        info.pppoe_auth_name = this.pppoe_auth_name;
        info.ip_address = this.ip_address;
        info.netmask = this.netmask;
        info.default_route = this.default_route;
        info.primary_dns = this.primary_dns;
        info.secondary_dns = this.secondary_dns;
        info.http_proxy_config = this.http_proxy_config;
        info.http_proxy_server = this.http_proxy_server;
        info.http_proxy_port = this.http_proxy_port;
        return info;
    }
}

@:native('SceNetEtherAddr')
@:structAccess
extern class SceNetEtherAddrExtern {
    public var data:Array<UInt8>;
}
#end