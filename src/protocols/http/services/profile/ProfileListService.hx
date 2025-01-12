package protocols.http.services.profile;

import sys.FileSystem;
import sys.io.File;
import sys.net.Socket;
import Config;
import protocols.http.HTTPRequest;
using tools.StringTools;

// This service returns non-variable system resources.
class ProfileListService extends AbstractHttpService {
    public function execute(request:HTTPRequest, socket:Socket):Dynamic {
        var response:Array<Dynamic> = [];

        var profileIds:Array<String> = FileSystem.readDirectory(Config.USER_HOME_PATH);
        for(profileId in profileIds)
        {
            var username:Null<String> = File.getContent('${Config.USER_HOME_PATH}/${profileId}/username.dat');
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