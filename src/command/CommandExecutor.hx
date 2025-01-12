package command;
class CommandExecutor {
    private var commands:Array<Command>  = [];

    public function new() {

    }

    public function addComamnd(command:Command):Void {
        commands.push(command);
    }

    public function execute():Void {
        while (commands.length > 0) {
            var command:Command = commands.shift();
            try {
                command.execute();
            } catch (e:Dynamic) {
                command.fail(e);
            }
        }
    }
}
