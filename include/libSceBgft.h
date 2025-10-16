// https://flatz.github.io/

#pragma once
#include <stdint.h>

extern "C" {

    // ------------------------------------------------------------
    // Enum: bgft_task_option_t
    // ------------------------------------------------------------
    enum bgft_task_option_t {
        BGFT_TASK_OPTION_NONE                    = 0x0,
        BGFT_TASK_OPTION_DELETE_AFTER_UPLOAD     = 0x1,
        BGFT_TASK_OPTION_INVISIBLE               = 0x2,
        BGFT_TASK_OPTION_ENABLE_PLAYGO           = 0x4,
        BGFT_TASK_OPTION_FORCE_UPDATE            = 0x8,
        BGFT_TASK_OPTION_REMOTE                  = 0x10,
        BGFT_TASK_OPTION_COPY_CRASH_REPORT_FILES = 0x20,
        BGFT_TASK_OPTION_DISABLE_INSERT_POPUP    = 0x40,
        BGFT_TASK_OPTION_DISABLE_CDN_QUERY_PARAM = 0x10000,
    };

    // Optional typedef for shorter name
    typedef enum bgft_task_option_t task_option_t;

    // ------------------------------------------------------------
    // Struct: bgft_download_param
    // ------------------------------------------------------------
    struct bgft_download_param {
        int user_id;
        int entitlement_type;
        const char* id;
        const char* content_url;
        const char* content_ex_url;
        const char* content_name;
        const char* icon_path;
        const char* sku_id;
        enum bgft_task_option_t option;   // Fixed: previously incomplete enum
        const char* playgo_scenario_id;
        const char* release_date;
        const char* package_type;
        const char* package_sub_type;
        unsigned long package_size;
    };

    // ------------------------------------------------------------
    // Struct: bgft_download_param_ex
    // ------------------------------------------------------------
    struct bgft_download_param_ex {
        struct bgft_download_param param;
        unsigned int slot;
    };

    // ------------------------------------------------------------
    // Struct: bgft_task_progress_internal
    // ------------------------------------------------------------
    struct bgft_task_progress_internal {
        unsigned int bits;
        int error_result;
        unsigned long length;
        unsigned long transferred;
        unsigned long length_total;
        unsigned long transferred_total;
        unsigned int num_index;
        unsigned int num_total;
        unsigned int rest_sec;
        unsigned int rest_sec_total;
        int preparing_percent;
        int local_copy_percent;
    };

    // ------------------------------------------------------------
    // Constants
    // ------------------------------------------------------------
    #define BGFT_INVALID_TASK_ID (-1)

    // ------------------------------------------------------------
    // Struct: bgft_init_params
    // ------------------------------------------------------------
    struct bgft_init_params {
        void* mem;
        unsigned long size;
    };

    // ------------------------------------------------------------
    // Function pointers (prototypes)
    // ------------------------------------------------------------
    int sceBgftServiceIntInit(struct bgft_init_params* params);
    int sceBgftServiceIntTerm(void);
    int sceBgftServiceIntDownloadRegisterTaskByStorageEx(struct bgft_download_param_ex* params, int* task_id);
    int sceBgftServiceIntDownloadRegisterTask(struct bgft_download_param* params, int* task_id);
    int sceBgftServiceIntDebugDownloadRegisterPkg(struct bgft_download_param* params, int* task_id);
    int sceBgftServiceIntDownloadStartTask(int task_id);
    int sceBgftServiceIntDownloadGetProgress(int task_id, struct bgft_task_progress_internal* progress);

} // extern "C"
