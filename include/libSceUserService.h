// https://github.com/LightningMods/PS4-daemon-writeup/blob/main/writeup.md

extern "C" {
    struct SceUserServiceLogin_struct {
    	int userId[4];
    };

    int *sceUserServiceGetLoginUserIdList(SceUserServiceLogin_struct *userIdList);

    int *sceUserServiceInitialize(void *);
    int sceUserServiceTerminate();
    int sceUserServiceGetForegroundUser(int*);

}