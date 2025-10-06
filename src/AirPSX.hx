import sys.thread.Thread;

import sys.net.Socket;
import cpp.lib.LibKernel;
using airpsx.tools.ArrayFilterTools;
using airpsx.tools.BytesTools;
import hx.concurrent.executor.Executor;
using StringTools;
using airpsx.tools.IntegerTools;
using airpsx.tools.Integer64Tools;

@:buildXml('
    <files id="haxe">
        <compilerflag value="-I${this_dir}/../../include"/>
    </files>

    <target id="haxe">
        <flag value="-lkernel" />
        <flag value="-lkernel_sys" />
        <!-- <flag value="-lSceIpmi" /> --> <!-- Required because including SceAppInstUtil Library without SceIpmi Library will break the sdk. -->
        <!-- <flag value="-lSceAppInstUtil" /> -->
        <flag value="-lSceNet" />
        <flag value="-lSceRandom" />
        <flag value="-lSceRegMgr" />
        <flag value="-lSceRemoteplay" />
        <flag value="-lSceSystemService" />
        <flag value="-lSceUserService" />
    </target>
')

class AirPSX {
	public static var isExiting:Bool = false;
	public static var socket:Socket;
	public static var executor:Executor;

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
			executor?.stop();

			if(executor != null && executor.state != STOPPED)
			{
				trace("wait executor stop");
			}

			var retryCount:Int = 0;
			var maxRetryCount:Int = 10;
			while (executor != null && executor.state != STOPPED && retryCount < maxRetryCount)
			{
				Sys.sleep(1);
				retryCount++;
			}

			if(executor != null && executor.state != STOPPED)
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