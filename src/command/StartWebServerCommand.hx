package command;
import sys.net.Host;
import sys.net.Socket;
import protocols.http.route.HttpRouter;
import lib.LibKernel;
import haxe.Exception;
import protocols.http.route.HttpRouterElement;
import haxe.io.Bytes;
import haxe.Json;
import Type.ValueType;
import haxe.CallStack;
import lib.LibSceSystemService;
import cpp.extern.ExternLibSceSystemService;
import protocols.http.HTTPRequest;
import protocols.http.HttpResponse;
using tools.ExecutorTools;


class StartWebServerCommand extends Command {
    public function new() {
        super();
    }

    public function execute():Void {
        var host:Host = new Host("0.0.0.0");
        var socket:Socket = AirPSX.socket = new Socket();
        try
        {
            socket.bind(host, Config.HTTP_PORT);
        }
        catch (e:Exception)
        {
            trace("Bind failed: " + e);
            LibKernel.sendNotificationRequest('Bind failed.');
            return;
        }

        HttpRouter.init();

        try {
            socket.listen(20); // big max connections

            var socketHost = socket.host();
            trace("HTTP Server TCP Listening on " + socketHost.host.host + ":" + socketHost.port);

            LibKernel.sendNotificationRequest('HTTP Server listening at ${Config.HTTP_PORT}');

            //LibSceSystemService.systemServiceLaunchWebBrowser('http://127.0.0.1:${Config.HTTP_PORT}/api/system/info');

            while(true) {
                socket.waitForRead();

                var clientSocket:Socket = socket.accept();


                AirPSX.executor.submitWithGC(() ->{

                    try {
                        var httpRequest:HTTPRequest = HTTPRequest.parseInput(clientSocket.input);

                        var routerElement:HttpRouterElement = HttpRouter.resolveRequest(httpRequest);
                        if(routerElement == null)
                        {
                            trace('HTTP Server request failed: ${httpRequest.method} ${httpRequest.path} ${httpRequest.path == "/api/blank"}');
                        }

                        var response = new HttpResponse();
                        if(routerElement == null)
                        {
                            response.statusCode = 404;
                            response.headers.set("Content-Type", "text/html");
                            response.body = "Page Not Found";
                        }else{
                            response.statusCode = 200;

                            var serviceResponseBytes:Bytes = Bytes.alloc(0);


                            if(!routerElement.getStream())
                            {
                                HTTPRequest.parseBody(clientSocket.input, httpRequest);
                            }
                            // Read the body if service is not streamed


                            trace('${httpRequest.method} ${httpRequest.path}, stream: ${routerElement.getStream()}');
                            var serviceResponse = routerElement.getHandler().execute(httpRequest, clientSocket);
                            if(serviceResponse == null)
                            {
                                clientSocket.output.close();
                                return;
                            }

                            if(Type.typeof(serviceResponse) == ValueType.TObject || Std.isOfType(serviceResponse, Array))
                            {
                                serviceResponseBytes = Bytes.ofString(Json.stringify(serviceResponse));
                                response.headers.set("Content-Type", "application/json");
                            }else if(Std.isOfType(serviceResponse, String)) {
                                serviceResponseBytes = Bytes.ofString(cast serviceResponse);
                                response.headers.set("Content-Type", "text/html");
                            }else if(Std.isOfType(serviceResponse, Bytes)) {
                                serviceResponseBytes = cast serviceResponse;
                            }else{
                                serviceResponseBytes = Bytes.ofString("Error Occured");
                                response.statusCode = 500;
                            }

                            response.bodyBytes = serviceResponseBytes;
                        }

                        clientSocket.output.write(response.toBytes());
                        clientSocket.output.flush();
                        clientSocket.output.close();
                    } catch (e:Exception)
                    {
                        try {
                            clientSocket.output.close();
                        } catch (e)
                        {

                        }
                        if(!AirPSX.isExiting)
                        {
                            var crashDump:String = 'HTTP Server request failed: ${e.message}\n${CallStack.toString(e.stack)}';
                            trace(crashDump);
                        }
                    } catch (e:Dynamic) {
                        try {
                            clientSocket.output.close();
                        } catch (e)
                        {

                        }
                        if(!AirPSX.isExiting)
                        {
                            trace("crash");
                            sys.io.File.saveContent('${Config.DATA_PATH}/webServer.dump', e);
                        }
                    }
                });
            }
        } catch(e:Exception) {
            if(!AirPSX.isExiting)
            {
                var crashDump:String = 'HTTP Server crashed: ${e.message}\n${CallStack.toString(e.stack)}';
                LibKernel.sendNotificationRequest(crashDump);
                trace(crashDump);
            }
        } catch (e:Dynamic) {
            if(!AirPSX.isExiting)
            {
                sys.io.File.saveContent('${Config.DATA_PATH}/webServer.dump', e);
            }
        }


    }
}
