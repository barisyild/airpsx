package protocols.http.services;

import sys.net.Socket;
import utils.TypeUtils;
import Type.ValueType;
import protocols.http.HTTPRequest;

abstract class AbstractHttpService extends AbstractService {

    public var path:EReg;
    public var stream:Bool = false;

    public function parseJson<T>(request:HTTPRequest, types:Map<String, Dynamic>):T
    {
        return parseJsonString(request.bodyBytes.toString(), types);
    }

    public function parseJsonString<T>(data:String, types:Map<String, Dynamic>):T
    {
        var jsonData:Dynamic = haxe.Json.parse(data);
        for(key in types.keys())
        {
            var value:Dynamic = Reflect.field(jsonData, key);
            if(value == null)
                continue;

            var targetType:Dynamic = types.get(key);
            value = parseType(value, targetType);

            Reflect.setField(jsonData, key, value);
        }

        return jsonData;
    }

    private function parseType(value:Dynamic, targetType:Dynamic):Dynamic
    {
        if(targetType == Int && Type.typeof(value) != ValueType.TInt)
        {
            value = Std.parseInt(value);
        } else if(targetType == Bool && Type.typeof(value) != ValueType.TBool)
        {
            trace(value);
            value = TypeUtils.parseBool(value);
        } else if(targetType == String && !Std.isOfType(value, String))
        {
            value = Std.string(value);
        } else if(Std.isOfType(targetType, Array))
        {
            if(!Std.isOfType(value, Array))
            {
                throw "Array is required";
            }

            var valueArray:Array<Dynamic> = cast value;
            var targetArrayType:Dynamic = targetType[0];
            for(i in 0...valueArray.length)
            {
                valueArray[i] = parseType(valueArray[i], targetArrayType);
            }
        }

        return value;
    }

    public abstract function execute(request:HTTPRequest, socket:Socket):Dynamic;
}