package airpsx.utils;
import rulescript.HxParser;
import hscript.Expr;
class RuleScriptUtils {
    public static function parse(code:String):{parser:HxParser, expr:Expr} {
        var parser:HxParser = new HxParser();
        parser.allowAll();
        var expr:Expr = parser.parse(code);
        return {parser: parser, expr: expr};
    }
}
