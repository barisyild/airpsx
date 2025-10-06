extern "C" {
    #define PLAYGOSCENARIOID_SIZE 3
    #define CONTENTID_SIZE 0x30
    #define LANGUAGE_SIZE 8

    #define NUM_LANGUAGES 30
    #define NUM_IDS 64

    typedef char playgo_scenario_id_t[PLAYGOSCENARIOID_SIZE];
    typedef char language_t[LANGUAGE_SIZE];
    typedef char content_id_t[CONTENTID_SIZE];

    typedef struct {
        content_id_t content_id;
        int content_type;
        int content_platform;
    } SceAppInstallPkgInfo;

    typedef struct {
        const char* uri;
        const char* ex_uri;
        const char* playgo_scenario_id;
        const char* content_id;
        const char* content_name;
        const char* icon_url;
    } MetaInfo;

    typedef struct {
        language_t languages[NUM_LANGUAGES];
        playgo_scenario_id_t playgo_scenario_ids[NUM_IDS];
        content_id_t content_ids[NUM_IDS];
        unsigned char unknown[6480]; // standard sony practice of wasting memory?
    } PlayGoInfo;

    int sceAppInstUtilInitialize(void);
    int sceAppInstUtilAppInstallPkg(const char* file_path, void* reserved);
    int sceAppInstUtilCheckAppSystemVer(const char* title_id, uint64_t buf, uint64_t bufs);
    int sceAppInstUtilAppPrepareOverwritePkg(const char* pkg_path);
    int sceAppInstUtilGetPrimaryAppSlot(const char* title_id, int* slot);
    int sceAppInstUtilAppUnInstall(const char* title_id);
    int sceAppInstUtilRegisterDownload(const char* content_id, const char* download_path, const char* icon_path, const char* title_name, const char* title_id);
    int sceAppInstUtilJson(const char* url);
    int sceAppInstUtilInstallByPackage(MetaInfo* arg1, SceAppInstallPkgInfo* pkg_info, PlayGoInfo* arg2);

}