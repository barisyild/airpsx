package command;
import lib.LibKernel;
import haxe.Exception;
import haxe.CallStack;
abstract class Command {
    private var executor:CommandExecutor;

    public function new() {
    }

    public abstract function execute():Void;

    public function fail(?e:Dynamic):Void {

        if(!Std.isOfType(e, Exception))
            e = @:privateAccess Exception.caught(e);

        if(Std.isOfType(e, Exception))
        {
            var exception:Exception = cast e;
            var crashDump:String = '${exception.message}\n${CallStack.toString(exception.stack)}';
            trace(crashDump);
        }else{
            sys.io.File.saveContent("fail.dump", e);
        }

        LibKernel.sendNotificationRequest('${Type.getClassName(Type.getClass(this))} command failed');
        AirPSX.exit(0);
    }
}
