// https://github.com/LightningMods/PS4-daemon-writeup/blob/main/writeup.md

extern "C" struct SceUserServiceLogin_struct {
	int userId[4];
};

extern "C" int *sceUserServiceGetLoginUserIdList(SceUserServiceLogin_struct *userIdList);

extern "C" int *sceUserServiceInitialize(void *);