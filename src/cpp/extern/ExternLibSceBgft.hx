package cpp.extern;

#if orbis
@:keep
@:include('libSceBgft.h')
extern class ExternLibSceBgft {
    @:native('BGFT_INVALID_TASK_ID')
    public static var BGFT_INVALID_TASK_ID:Int;

    @:native('BGFT_TASK_OPTION_DISABLE_CDN_QUERY_PARAM')
    public static var BGFT_TASK_OPTION_DISABLE_CDN_QUERY_PARAM:Int;

    //int sceBgftServiceIntInit(struct bgft_init_params* params);
    @:native('sceBgftServiceIntInit')
    public static function sceBgftServiceIntInit(params:AbstractPointer<BgftInitParams>):Int;

    //int sceBgftServiceIntTerm(void);
    @:native('sceBgftServiceIntTerm')
    public static function sceBgftServiceIntTerm():Int;

    //int sceBgftDownloadRegisterTaskByStorageEx(struct bgft_download_param_ex* params, int* task_id);
    @:native('sceBgftServiceIntDownloadRegisterTaskByStorageEx')
    public static function sceBgftServiceIntDownloadRegisterTaskByStorageEx(params:AbstractPointer<BgftDownloadParamEx>, task_id:AbstractPointer<Int>):Int;

    //int sceBgftServiceIntDownloadRegisterTask(struct bgft_download_param* params, int* task_id);
    @:native('sceBgftServiceIntDownloadRegisterTask')
    public static function sceBgftServiceIntDownloadRegisterTask(params:AbstractPointer<BgftDownloadParam>, task_id:AbstractPointer<Int>):Int;

    @:native('sceBgftServiceIntDebugDownloadRegisterPkg')
    public static function sceBgftServiceIntDebugDownloadRegisterPkg(params:AbstractPointer<BgftDownloadParam>, task_id:AbstractPointer<Int>):Int;

    //int sceBgftDownloadStartTask(int task_id);
    @:native('sceBgftServiceIntDownloadStartTask')
    public static function sceBgftServiceIntDownloadStartTask(task_id:Int):Int;

    //int sceBgftDownloadGetProgress(int task_id, struct bgft_task_progress_internal* progress);
    @:native('sceBgftServiceIntDownloadGetProgress')
    public static function sceBgftServiceIntDownloadGetProgress(task_id:Int, progress:AbstractPointer<BgftTaskProgressInternal>):Int;
}

@:native('bgft_init_params')
@:structAccess
extern class BgftInitParams {
    public var size:cpp.Int32;
    public var mem:Star<cpp.Void>;
    public var reserved:cpp.Int32;
    public static inline function create():BgftInitParams {
        return untyped __cpp__('{}');
    }
}

@:native('bgft_download_param_ex')
@:structAccess
extern class BgftDownloadParamEx {
    public var param:BgftDownloadParam;
    public var slot:Int32;
    public var reserved:cpp.Int32;
    public static inline function create():BgftDownloadParamEx {
        return untyped __cpp__('{}');
    }
}

@:native('bgft_download_param')
@:structAccess
extern class BgftDownloadParam {
    public var entitlement_type:cpp.Int32;
    public var id:ConstCharStar;
    public var content_url:ConstCharStar;
    public var content_name:ConstCharStar;
    public var icon_path:ConstCharStar;
    public var playgo_scenario_id:ConstCharStar;
    public var option:cpp.Int32;
    public static inline function create():BgftDownloadParam {
        return untyped __cpp__('{}');
    }
}

@:native('bgft_task_progress_internal')
@:structAccess
extern class BgftTaskProgressInternal {
    public var total_size:cpp.Int64;
    public var downloaded_size:cpp.Int64;
    public var state:cpp.Int32;
    public var error_code:cpp.Int32;
    public var reserved:cpp.Int32;
    public static inline function create():BgftTaskProgressInternal {
        return untyped __cpp__('{}');
    }
}
#end