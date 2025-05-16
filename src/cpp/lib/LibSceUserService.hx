package cpp.lib;

#if orbis
import cpp.extern.ExternLibSceUserService;
import cpp.Pointer;
import cpp.Int32;
class LibSceUserService {
    public static function getLoginUserIdList():Array<Int>
    {
        var userIdListStruct:SceUserServiceLoginStruct = SceUserServiceLoginStruct.create();
        if(ExternLibSceUserService.sceUserServiceGetLoginUserIdList(userIdListStruct) != 0)
        {
            throw "sceUserServiceGetLoginUserIdList failed";
        }

        var userIdList:Array<Int> = new Array<Int>();
        for(i in 0...4)
        {
            var userId:Int32 = userIdListStruct.userId[i];
            if(userId != -1)
            {
                userIdList.push(userId);
            }
        }
        if (userIdList.length == 0)
        {
            throw "No user logged in";
        }


        return userIdList;
    }

    public static function initialize():Bool
    {
        return ExternLibSceUserService.sceUserServiceInitialize() == 0;
    }

    @:hscriptVariable("sceUserServiceGetForegroundUser")
    public static function userServiceGetForegroundUser():Int
    {
        var user_id:Int32 = -1;
        ExternLibSceUserService.sceUserServiceGetForegroundUser(user_id);
        return user_id;
    }
}
#end