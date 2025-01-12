import sys.thread.Thread;

import sys.net.Socket;
import lib.LibKernel;
using tools.ArrayFilterTools;
using tools.BytesTools;
import command.CommandExecutor;
import command.SetupPublicCommand;
import command.StartWebServerCommand;
import command.SchedulerCommand;
import hx.concurrent.executor.Executor;
import command.InitializeCommand;
import command.SetupDatabaseCommand;
using tools.ExecutorTools;
using StringTools;
using tools.IntegerTools;
using tools.Integer64Tools;
import hscript.HScriptData;
import externs.sys.ExternMount;
import utils.FileUtils;

class AirPSX {
	public static var socket:Socket;
	public static var isExiting:Bool = false;

	public static var executor:Executor;

	static public function main() {
		// Server shutdown
		#if (!release)
		Thread.create(() -> {
			Sys.sleep(1000);

			exit(0);
		});
		#end

		executor = Executor.create(4);

		Config.init();
		HScriptData.init();

		// Kill old process
		try
		{
			var h = new haxe.Http('http://127.0.0.1:${Config.HTTP_PORT}/api/server/kill');
			var r = null;
			h.onData = function(d) {
				r = d;
			}
			h.onError = function(e) {
				trace("onError");
				throw e;
			}
			trace("request start");
			h.cnxTimeout = 1;
			h.request(true);
			trace("request end");
			if(r == "OK")
			{
				trace("The old process was found and killed.");
				Sys.sleep(1);
			}
		}
		catch (e)
		{

		}

		//ExternLibSceSystemService.sceLncUtilLoadExec("/system_ex/common_ex/lib/WebProcessWebApp.self", null, 0);

		//ExternLibSceSystemService.sceSystemServiceLoadExec("/system_ex/common_ex/lib/WebProcessWebApp.self", null);

		trace("Current PID: " + cpp.NativeSys.sys_get_pid());

		var commandExecutor = new CommandExecutor();
		commandExecutor.addComamnd(new SetupPublicCommand());
		commandExecutor.addComamnd(new SetupDatabaseCommand());
		commandExecutor.addComamnd(new InitializeCommand());
		commandExecutor.addComamnd(new SchedulerCommand());
		commandExecutor.addComamnd(new StartWebServerCommand()); // Infinite loop, always last command
		commandExecutor.execute();
	}

	public static function exit(code:Int):Void
	{
		isExiting = true;

		if(socket != null)
		{
			trace("close socket");
			socket.shutdown(true, true);
			socket.close();
			socket = null;

			trace("close executor");
			executor.stop();

			if(executor.state != STOPPED)
			{
				trace("wait executor stop");
			}

			var retryCount:Int = 0;
			var maxRetryCount:Int = 10;
			while (executor.state != STOPPED && retryCount < maxRetryCount)
			{
				Sys.sleep(1);
				retryCount++;
			}

			if(executor.state != STOPPED)
			{
				trace("will be forcibly closed because the executor has not been stopped.");
			}
			else
			{
				trace("executor is stopped.");
			}

			trace("send notification");
			LibKernel.sendNotificationRequest('HTTP Server Closing...');

			trace("socket close operation completed");
		}

		trace("bye");
		Sys.exit(code);
	}
}