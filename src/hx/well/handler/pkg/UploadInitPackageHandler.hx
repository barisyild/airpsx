package hx.well.handler.pkg;

import hx.well.handler.AbstractHandler;
import hx.well.http.Request;
import hx.well.http.AbstractResponse;
import cpp.lib.LibSceAppInstUtil;
using StringTools;

import uuid.Uuid;
import airpsx.pkg.PackageVo;
import hx.well.http.ResponseBuilder;
import sys.thread.Thread;
import haxe.Int64;
using airpsx.tools.OutputTools;

#if prospero
import hx.well.facades.DBStatic;
import airpsx.type.DatabaseType;
#end

// TODO: Handle sockets with better way
class UploadInitPackageHandler extends AbstractHandler {
    public function execute(request:Request):AbstractResponse {
        // Create serve package session key
        var sessionKey:String = Uuid.nanoId(32);
        var packageVo:PackageVo = new PackageVo();
        packageVo.sessionKey = sessionKey;
        packageVo.fileSize = Int64.parseString(request.query("size"));

        var titleId:String = request.query("titleId");
        var contentName:String = request.query("title");
        var iconUrl:String = request.query("iconPath");

        // Reset installation progress if the title is not already installed
        #if prospero
        var contentStatusResultSet = DBStatic.connection(DatabaseType.APP).query("SELECT contentStatus FROM tbl_contentinfo WHERE titleId = ? LIMIT 1", titleId);
        if(contentStatusResultSet.length == 1) {
            var contentStatus = contentStatusResultSet.next().contentStatus;
            if(contentStatus != 0) {
                LibSceAppInstUtil.appInstUtilAppUnInstall(titleId);
            }
        }
        #end

        PackageVo.current = packageVo;

        #if orbis
        // Start installation in a new thread
        Thread.create(() -> {
            // Enter GC free zone for installation
            cpp.vm.Gc.enterGCFreeZone();

            LibSceAppInstUtil.appInstUtilInstallByPackage('http://127.0.0.1:1214/api/package/${sessionKey}.pkg', contentName, iconUrl);

            // Exit GC free zone after installation
            cpp.vm.Gc.exitGCFreeZone();
        });


        // Wait for Console Installer to want data
        Sys.sleep(3);
        #end

        return ResponseBuilder.asJson({
            status: "success",
            sessionKey: sessionKey
        });
    }
}