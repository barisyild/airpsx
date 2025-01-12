package macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ModuleType;
import haxe.macro.Type.ClassField;
import haxe.macro.Type.ClassType;

class HScriptVariableMacro {
    public static function run():Void {
        Context.onAfterTyping(types -> {
            if(hasTypeFromClassName(types, "HScriptDataGenerated"))
                return;

            var exprs:Array<Expr> = [];
            for (type in types) {
                switch (type) {
                    case TClassDecl(classTypeRef):
                        var classType:ClassType = classTypeRef.get();

                        processHScriptVariableMetadata(exprs, classType);

                        var fields:Array<ClassField> = classType.statics.get();
                        for (field in fields) {
                            processHScriptVariableMetadata(exprs, classType, field);
                        }
                    default:
                }
            }

            // create variables field with exprs data
            var variablesField:Field = {
                pos: Context.currentPos(),
                name: "variables",
                meta: null,
                kind: FieldType.FVar(macro:Map<String, Any>, macro $a{exprs}),
                doc: null,
                access: [Access.APublic, Access.AStatic]
            };

            // create hscript.HScriptDataGenerated type
            var HScriptDataGeneratedType:TypeDefinition = {
                pack: ["hscript"],
                name: "HScriptDataGenerated",
                fields: [variablesField],
                kind: {
                    TDClass();
                },
                pos: Context.currentPos()
            }
            Context.defineType(HScriptDataGeneratedType);
        });
    }

    private static function processHScriptVariableMetadata(exprs:Array<Expr>, classType:ClassType, ?field:ClassField):Void
    {
        var metaData:Metadata = field != null ? field.meta.get() : classType.meta.get();
        var hscriptVariableMetadata:Array<MetadataEntry> = metaData.filter(metadataEntry -> metadataEntry.name == ":hscriptVariable");
        if(hscriptVariableMetadata.length > 0)
        {
            var variableString:String = getConstString(hscriptVariableMetadata[0].params[0]);
            if(field == null)
                exprs.push(macro $v{variableString} => $p{classType.module.split(".")});
            else
                exprs.push(macro $v{variableString} => $p{classType.module.split(".").concat([field.name])});
        }
    }

    private static function hasTypeFromClassName(types:Array<haxe.macro.Type.ModuleType>, className:String):Bool
    {
        for(type in types)
        {
            switch (type) {
                case TClassDecl(cls):
                    var classType:ClassType = cls.get();
                    if(classType.name == className)
                        return true;
                default:
            }
        }

        return false;
    }

    private static function getConstString(expr:Expr):String
    {
        var str:String = null;
        switch (expr.expr)
        {
            case EConst(c):
                switch (c)
                {
                    case CString(s):
                        str = s;
                    default:
                        throw "String not found.";
                }
            default:

        }
        return str;
    }
}