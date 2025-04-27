package airpsx.command;
import hx.well.console.AbstractCommand;
import airpsx.pkg.PackageVo;
import hx.well.http.Request;
import haxe.Int64;
import sys.thread.Mutex;
import hx.well.http.ResponseStatic.response;
import haxe.io.PartialInput;
import hx.well.WebServer;
import haxe.Exception;
import haxe.CallStack;
import hx.well.http.ResponseStatic;
using airpsx.tools.InputTools;
using airpsx.tools.ArrayTools;
class ServePackageCommand extends AbstractCommand {
    public static var packageVo:Null<PackageVo> = null;
    public static var packageMutex:Mutex = new Mutex();

    public override function group():String {
        return "package";
    }

    public function signature():String {
        return "serve";
    }

    public function description():String {
        return "Serve package";
    }

    public function handle<T>():T {
        var acquired = packageMutex.tryAcquire();
        if(!acquired)
            return cast false;

        // Initialize response static
        @:privateAccess ResponseStatic.reset();

        try {
            var packageVo:PackageVo = ServePackageCommand.packageVo;
            if(packageVo != null) {
                processPackage(packageVo);
            }
        } catch (e:Exception) {
            packageMutex.release();
            trace(CallStack.toString(e.stack));
            throw e;
        }
        packageMutex.release();

        return cast true;
    }

    private function processPackage(packageVo:PackageVo):Void {
        // Only one thread can acquire the mutex
        var acquired = packageVo.mutex.tryAcquire();
        if(!acquired)
            return;

        try {
            var request = this.findSmallestRequest(packageVo);
            if(request == null)
                return;

            var rangeStart:Int64 = request.attributes.get("start");
            var rangeEnd:Null<Int64> = request.attributes.get("end");
            var fileSize:Int64 = packageVo.fileSize;
            var contentLength:Int64 = rangeEnd - rangeStart + 1;

            if(rangeStart < packageVo.pos) {
                while (packageVo.pos < rangeStart) {
                    var count = Std.int(Math.min(cast rangeStart - packageVo.pos, 65535));
                    packageVo.sourceSocket.input.read(count);
                    packageVo.pos += count;
                }
            }

            packageVo.pos += contentLength;
            packageVo.lastAccessTime = Sys.time();

            var response = response()
                .asInput(new PartialInput(packageVo.sourceSocket.input.asUncloseable(), contentLength), contentLength)
                .status(206)
                .header("Content-Range", 'bytes ${rangeStart}-${rangeEnd}/${fileSize}')
                .header("Content-Type", "application/octet-stream")
                .header("Accept-Ranges", "bytes")
                .onAfter(() -> {
                    packageVo.requests.remove(request);

                var predataOffset:Int64 = packageVo.predataOffset;
                    if(rangeEnd == predataOffset - 1 || rangeEnd == fileSize - 1) {
                        // Remove session
                        ServePackageCommand.packageVo = null;

                        WebServer.writeResponse(
                            packageVo.sourceSocket,
                            response().asJson({
                                status: "success"
                            })
                        );

                        packageVo.dispose();
                    }
                }
            );

            WebServer.writeResponse(request.socket, response);
        } catch (e) {
            packageVo.mutex.release();
            throw e;
        }

        packageVo.mutex.release();
    }

    private function findSmallestRequest(packageVo:PackageVo):Null<Request> {
        var request:Request = null;

        var smallestKey:Null<Int64> = null;
        for(packageVoRequest in packageVo.requests) {
            var key:Null<Int64> = packageVoRequest.attributes.get("start");

            if(smallestKey == null)
            {
                smallestKey = key;
                request = packageVoRequest;
                continue;
            }

            if(key < smallestKey)
            {
                smallestKey = key;
                request = packageVoRequest;
            }
        }

        return request;
    }
}
