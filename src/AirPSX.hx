import sys.net.Socket;
import cpp.lib.LibKernel;
using airpsx.tools.ArrayFilterTools;
using airpsx.tools.BytesTools;
import hx.concurrent.executor.Executor;
import cpp.lib.LibSceAppInstUtil;
import cpp.lib.LibSceBgft;
import cpp.lib.LibSceUserService;
import cpp.lib.LibSceRemoteplay;
using StringTools;
using airpsx.tools.IntegerTools;
using airpsx.tools.Integer64Tools;

#if prospero
@:buildXml('<include name="${this_dir}/../../toolchain/prospero-setup.xml" />')
#elseif orbis
@:buildXml('<include name="${this_dir}/../../toolchain/orbis-setup.xml" />')
#end
class AirPSX {
	public static var isExiting:Bool = false;
	public static var socket:Socket;
	public static var executor:Executor;

	public static function exit(code:Int):Void
	{
		isExiting = true;

        #if orbis
        if(!LibSceUserService.terminate())
            LibKernel.sendNotificationRequest('sceUserServiceTerminate failed');

        if(!LibSceAppInstUtil.terminate())
            LibKernel.sendNotificationRequest('sceLibSceAppInstUtilTerminate failed');

        if(!LibSceRemoteplay.terminate())
            LibKernel.sendNotificationRequest('sceLibSceRemoteplayTerminate failed');

        #if !prospero
        if(!LibSceBgft.terminate())
            LibKernel.sendNotificationRequest('sceLibSceBgftTerminate failed');
        #end
        #end

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