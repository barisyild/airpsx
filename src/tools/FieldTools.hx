package tools;
import haxe.macro.Expr.Field;
using tools.ArrayFilterTools;

class FieldTools {
    public static function getField(fields:Array<Field>, fieldName:String):Null<Field> {
        return fields.filterOne(field -> field.name == fieldName);
    }

    public static function getFieldOrFail(fields:Array<Field>, fieldName:String):Field {
        var field:Null<Field> = getField(fields, fieldName);
        if(field == null)
            throw '${fieldName} field not found';

        return field;
    }
}
