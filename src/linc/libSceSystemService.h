// https://github.com/LightningMods/PS4-daemon-writeup/blob/main/writeup.md

enum Flag : uint64_t {
    Flag_None = 0,
    SkipLaunchCheck = 1,
    SkipResumeCheck = 1,
    SkipSystemUpdateCheck = 2,
    RebootPatchInstall = 4,
    VRMode = 8,
    NonVRMode = 16,
	Pft = 32UL,
	RaIsConfirmed = 64UL,
	ShellUICheck = 128UL
};

struct LncAppParam {
    uint32_t sz;
    uint32_t user_id;
    uint32_t app_opt;
    uint64_t crash_report;
    uint64_t check_flag;
};

//returns the Systems runetime app id
extern "C" int sceLncUtilLaunchApp(const char* tid, const char* argv[], LncAppParam* param);
extern "C" int sceSystemServiceLaunchWebBrowser(const char *uri);
extern "C" int sceSystemServiceLaunchWebApp(const char* url);