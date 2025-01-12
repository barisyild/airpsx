struct notify_request {
  char useless1[45];
  char message[3075];
};

typedef struct app_info {
  uint32_t app_id;
  uint64_t unknown1;
  char     title_id[14];
  char     unknown2[0x3c];
} app_info_t;

extern "C" int sceKernelGetCpuTemperature(int *);
extern "C" int64_t sceKernelGetCpuFrequency();
//extern "C" int sysctlbyname(char*, void*, size_t*, void*, size_t);
extern "C" int sceKernelSendNotificationRequest(int, notify_request*, size_t, int);
extern "C" int sceKernelGetSocSensorTemperature(int, int *);
extern "C" int sceKernelGetAppInfo(pid_t pid, app_info *info);
extern "C" int kernel_get_ucred_authid(pid_t pid);
extern "C" int sceKernelGetAppCategoryType(pid_t pid, int *categoryType);
extern "C" int *sceKernelLoadStartModule(const char *name, uint64_t argc, const void *argv, uint32_t flags, void *, int *result);
extern "C" void *getargv(void);
extern "C" int *getargc(void);