package cpp.lib;

#if orbis
import haxe.io.Bytes;
import cpp.lib.LibKernelSys;
using StringTools;
using tools.StringTools;

class Systemctl {
    public static var hardwareMachine(get, never):String;
    public static function get_hardwareMachine():String
    {
        return readStringByName("hw.machine");
    }

    public static var hardwareModel(get, never):String;
    public static function get_hardwareModel():String
    {
        return readStringByName("hw.model");
    }

    public static var kernelCpuMode(get, never):Int;
    public static function get_kernelCpuMode():Int
    {
        return readByteByName("kern.cpumode");
    }

    public static var kernelCpuModeGame(get, never):Int;
    public static function get_kernelCpuModeGame():Int
    {
        return readByteByName("kern.cpumode_game");
    }

    public static var kernelOsType(get, never):String;
    public static function get_kernelOsType():String
    {
        return readStringByName("kern.ostype");
    }

    public static var kernelPs4SdkVersion(get, never):String;
    public static function get_kernelPs4SdkVersion():String
    {
        return readVersionByName("kern.ps4_sdk_version");
    }


    public static var kernelSdkVersion(get, never):String;
    public static function get_kernelSdkVersion():String
    {
        return readVersionByName("kern.sdk_version");
    }

    public static var kernelUpdVersion(get, never):String;
    public static function get_kernelUpdVersion():String
    {
        return readVersionByName("kern.upd_version");
    }

    public static var kernelVersion(get, never):String;
    public static function get_kernelVersion():String
    {
        return readStringByName("kern.version");
    }

    public static var kernelBootTime(get, never):Int;
    public static function get_kernelBootTime():Int
    {
        return readUInt32ByName("kern.boottime");
    }


    public static function readVersionByName(key:String):Null<String>
    {
        var str:Null<UInt> = @:inline readUInt32ByName(key);
        if(str == null)
            return null;

        // First, let's convert the data to a string in the appropriate format
        var integerPart = (str >> 24) & 0xff;
        var fractionalPart = (str >> 12) & 0xfff;

        var integerPartHex = integerPart.hex(2);
        var fractionalPartHex = fractionalPart.hex(3).substr(0, 2);

        return '${integerPartHex}.${fractionalPartHex}';
    }

    public static function readByteByName(key:String):Null<Int>
    {
        var data:Null<Bytes> = LibSysCtl.getByName(key);
        if(data == null)
            return null;

        return data.get(0);
    }

    public static function readUInt32ByName(key:String):Null<UInt>
    {
        var data:Null<Bytes> = LibSysCtl.getByName(key);
        if(data == null)
            return null;

        return data.getInt32(0);
    }

    public static function readStringByName(key:String):Null<String>
    {
        var data:Null<Bytes> = LibSysCtl.getByName(key);
        if(data == null)
            return null;

        return data.toString().truncateAtNull().trim();
    }
}
#end