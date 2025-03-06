package airpsx.service;

import sys.net.Socket;
import hx.well.service.AbstractService;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
using airpsx.tools.StringTools;
using StringTools;


class BlankService extends AbstractService {
    public function execute(request:Request):AbstractResponse {
        return {data: ""};
    }
}