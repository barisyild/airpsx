package protocols.http.services;

import sys.net.Socket;
import cpp.extern.ExternLibSceSystemService;
import protocols.http.HTTPRequest;
using tools.StringTools;
using StringTools;


class BlankService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {

        //trace(ExternLibSceSystemService.sceSystemServiceLaunchWebApp("http://google.com/"));
        //ExternLibSceSystemService.sceSystemServiceLaunchWebBrowser("http://google.com/");
        //ExternLibSceSystemService.sceSystemServiceLaunchWebApp("http://127.0.0.1:1214/");

        return {data: ""};
    }
}