package hx.well.handler.profile;

import sys.FileSystem;
import sys.io.File;
import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import airpsx.Const;
using airpsx.tools.StringTools;

// This service returns non-variable system resources.
class ProfileListHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        var response:Array<Dynamic> = [];

        var profileIds:Array<String> = FileSystem.readDirectory(Const.USER_HOME_PATH);
        for(profileId in profileIds)
        {
            var usernameDatPath:String = '${Const.USER_HOME_PATH}/${profileId}/username.dat';
            if(!FileSystem.exists(usernameDatPath))
                continue;

            var username:Null<String> = File.getContent(usernameDatPath);
            if(username == null)
                continue;

            var userData:UserData = {
                profileId: profileId,
                username: username.truncateAtNull(),
            };
            response.push(userData);
        }

        return response;
    }
}


typedef UserData = {
    profileId:String,
    username:String,
}