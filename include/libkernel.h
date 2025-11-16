extern "C" {
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

    int sceKernelGetCpuTemperature(int *);
    int64_t sceKernelGetCpuFrequency();
    //int sysctlbyname(char*, void*, size_t*, void*, size_t);
    int sceKernelSendNotificationRequest(int, notify_request*, size_t, int);
    int sceKernelGetSocSensorTemperature(int, int *);
    int sceKernelGetAppInfo(pid_t pid, app_info *info);
    int kernel_get_ucred_authid(pid_t pid);
    int sceKernelGetAppCategoryType(pid_t pid, int *categoryType);
    int *sceKernelLoadStartModule(const char *name, uint64_t argc, const void *argv, uint32_t flags, void *, int *result);
    void *getargv(void);
    int *getargc(void);
    int sceKernelClockGettime(clockid_t clock_id, timespec* timeVal);
}