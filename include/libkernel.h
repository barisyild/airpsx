#ifndef ORBIS_KERNEL_H
#define ORBIS_KERNEL_H

#include <stdint.h>
#include <stddef.h>
#include <time.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct notify_request {
    char useless1[45];
    char message[3075];
} notify_request;

typedef struct app_info {
    uint32_t app_id;
    uint64_t unknown1;
    char     title_id[14];
    char     unknown2[0x3c];
} app_info;

int sceKernelGetCpuTemperature(int *);
int64_t sceKernelGetCpuFrequency();
int sceKernelSendNotificationRequest(int, notify_request*, size_t, int);
int sceKernelGetSocSensorTemperature(int, int *);
int sceKernelGetAppInfo(pid_t pid, app_info *info);
int kernel_get_ucred_authid(pid_t pid);
int sceKernelGetAppCategoryType(pid_t pid, int *categoryType);
int sceKernelLoadStartModule(const char *name, uint64_t argc, const void *argv,
                             uint32_t flags, void *, int *result);
void *getargv(void);
int *getargc(void);
int sceKernelClockGettime(clockid_t clock_id, struct timespec* timeVal);
int sceKernelDlsym(int handle, const char *symbol, void **address);
const char* sceKernelGetFsSandboxRandomWord(void);

/* File ops */
int sceKernelClose(int fd);
int sceKernelRead(int fd, void *data, size_t size);
off_t sceKernelLseek(int, off_t, int);
void sceKernelSync(void);
int sceKernelUsleep(int);
int sceKernelOpen(const char *path, int flags, int mode);
int sceKernelWrite(int fd, const void *data, size_t size);

#ifdef __cplusplus
}
#endif

#endif