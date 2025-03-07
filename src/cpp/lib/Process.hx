package cpp.lib;

#if orbis
import cpp.Pointer;
import cpp.extern.ExternLibKernel;
import cpp.extern.ExternLibKernel.AppInfoStruct;
import cpp.extern.sys.ExternUser.KInfoProcStruct;
import cpp.extern.sys.ExternSysctl.ExternSysCtl;
import haxe.io.Bytes;
import cpp.Int32;
import cpp.PidT;
import cpp.UInt64;
import cpp.UInt32;
import cpp.extern.ExternUnistd;
using airpsx.tools.BytesTools;
using StringTools;
import cpp.SizeT;
import cpp.extern.ApplicationCategoryType;
import cpp.extern.sys.ExternUser.KInfoProcTypedef;

@:hscriptVariable("Process")
class Process {
    public static function getProcessList():Array<KInfoProcTypedef> {
        var mib:Array<Int32> = [1, 14, 8, 0];
        var bufSize:SizeT = 0;

        ExternSysCtl.sysctl(mib, 4, null, bufSize, null, 0);
        var bytes = Bytes.alloc(bufSize);
        var bytesPointer =	bytes.toPointer();

        var pageSize:Int = ExternUnistd.getpagesize();

        ExternSysCtl.sysctl(mib, 4, bytesPointer.raw, bufSize, null, 0);

        var kInfoProcStructs:Array<KInfoProcTypedef> = [];
        var totalStructSize:Int = 0;

        while (totalStructSize < bufSize)
        {
            var kInfoProcStructPointer:Pointer<KInfoProcStruct> = bytesPointer.reinterpret();
            var kInfoProcStruct:KInfoProcStruct = kInfoProcStructPointer.ref;
            var structSize:Int = kInfoProcStruct.structSize;
            if(structSize == 0)
            {
                trace("Infinte loop detected");
                return null;
            }

            var appInfo:AppInfoTypedef = LibKernel.getAppInfo(kInfoProcStruct.pid);

            var rssize:Int = kInfoProcStruct.rssize;
            kInfoProcStructs.push({
                pid: kInfoProcStruct.pid,
                ppid: kInfoProcStruct.ppid,
                pgid: kInfoProcStruct.pgid,
                sid: kInfoProcStruct.sid,
                emul: kInfoProcStruct.emul,
                stat: kInfoProcStruct.stat,
                comm: kInfoProcStruct.comm,
                structSize: structSize,
                rssize: rssize,
                start: kInfoProcStruct.ki_start.tv_sec,
                pageSize: pageSize,
                categoryType: LibKernel.getAppCategoryType(kInfoProcStruct.pid),
                //authID: ExternLibKernel.kernel_get_ucred_authid(kInfoProcStruct.pid),
                titleID: appInfo.titleID,
                appID: appInfo.appID,
                appType: 0,
                //unknown1: appInfo.unknown1,
                //unknown2: appInfo.unknown2
            });

            totalStructSize += structSize;
            bytesPointer = bytesPointer.add(structSize);
        }

        return kInfoProcStructs;
    }

    public static function getRunningApp():Null<KInfoProcTypedef>
    {
        var processList = Process.getProcessList();
        processList = processList.filter(function(proc){
            return proc.categoryType == ApplicationCategoryType.NATIVE_GAME || proc.categoryType == ApplicationCategoryType.ORBIS_GAME || proc.categoryType == ApplicationCategoryType.SYSTEM_BUILTIN_APP || proc.categoryType == ApplicationCategoryType.WEB_BASED_MEDIA_APP || proc.categoryType == ApplicationCategoryType.RNPS_MEDIA_APP;
        });

        // First order is native games, then system apps
        processList.sort(function(a, b){
            if(a.categoryType == b.categoryType)
                return 0;
            else if(a.categoryType == ApplicationCategoryType.NATIVE_GAME || a.categoryType == ApplicationCategoryType.ORBIS_GAME)
                return -1;
            else
                return 1;
        });

        return processList.length > 0 ? processList[0] : null;
    }

    public static function getKernelProcess():KInfoProcTypedef
    {
        var processList = Process.getProcessList();
        processList = processList.filter(function(proc){
            return proc.comm == "kernel";
        });
        return processList.length > 0 ? processList[0] : null;
    }

    public static function currentProcess():KInfoProcTypedef {
        var currentPid:PidT = cpp.NativeSys.sys_get_pid();

        var processList = Process.getProcessList();
        processList = processList.filter(function(proc){
            return proc.pid == currentPid;
        });
        return processList[0];
    }
}
#end