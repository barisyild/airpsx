extern "C" {
    int sceAppInstUtilInitialize(void);
    int sceAppInstUtilAppInstallPkg(const char* file_path, void* reserved);
    int sceAppInstUtilCheckAppSystemVer(const char* title_id, uint64_t buf, uint64_t bufs);
    int sceAppInstUtilAppPrepareOverwritePkg(const char* pkg_path);
    int sceAppInstUtilGetPrimaryAppSlot(const char* title_id, int* slot);
    int sceAppInstUtilAppUnInstall(const char* title_id);
    int sceAppInstUtilRegisterDownload(const char* content_id, const char* download_path, const char* icon_path, const char* title_name, const char* title_id);
    int sceAppInstUtilJson(const char* url);
}