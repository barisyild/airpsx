package lib;

#if cpp
enum abstract LncAppParamFlag(cpp.Int32)
{
    var Flag_None = 0;
    var SkipLaunchCheck = 1;
    var SkipResumeCheck = 1;
    var SkipSystemUpdateCheck = 2;
    var RebootPatchInstall = 4;
    var VRMode = 8;
    var NonVRMode = 16;
}
#end