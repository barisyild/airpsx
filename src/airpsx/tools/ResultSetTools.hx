package airpsx.tools;
import sys.db.ResultSet;
import sys.net.Socket;
using StringTools;
class ResultSetTools {
    public static function writeJsonArray(resultSet:ResultSet, socket:Socket, fields:Array<String>, ?resultSetReplacer:Dynamic->Void) {
        socket.write("[");

        while (resultSet.hasNext()) {
            var result = resultSet.next();

            if(resultSetReplacer != null)
                resultSetReplacer(result);
            //trace(result);

           var fieldNames:Array<String> = Reflect.fields(result);

            socket.write("{");
            for (i in 0...fieldNames.length) {
                var fieldName = fieldNames[i];
                var fieldValue:Dynamic = Reflect.field(result, fieldName);
                socket.write('"${fieldName}":');

                var value:String;
                if(fields.contains(fieldName))
                {
                    value = resultSet.getResult(fields.indexOf(fieldName));
                }else{
                    value = fieldValue;
                }

                if(fieldValue == null)
                {
                    socket.write('""');
                }else if(Std.isOfType(fieldValue, String))
                {
                    socket.write('"${value}"');
                }else{
                    socket.write(value);
                }

                if (i < fieldNames.length - 1) {
                    socket.write(',');
                }
            }
            socket.write('}');
            if (resultSet.hasNext()) {
                socket.write(',');
            }
        }

        socket.write(']');
    }
}