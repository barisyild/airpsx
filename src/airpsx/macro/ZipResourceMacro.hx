package airpsx.macro;
import haxe.macro.Expr.Field;
import haxe.macro.Context;
import sys.FileSystem;
import haxe.zip.Writer;
import haxe.io.BytesOutput;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr;
import haxe.crypto.Md5;
import haxe.zip.Entry;
import haxe.crypto.Base64;
import airpsx.utils.ZipUtils;
import haxe.ds.Either;
import haxe.io.Bytes;
import haxe.io.Encoding;
import airpsx.utils.StringUtils;
import haxe.io.BytesData;
using airpsx.tools.ArrayFilterTools;
using airpsx.tools.FieldTools;

class ZipResourceMacro {
    public static function build(folders:Any, fieldData:{bytesField:String, hashField:String}):Array<Field> {
        var pathArray:Array<String> = [];
        if(Std.isOfType(folders, String))
            pathArray.push(cast folders);
        else if(Std.isOfType(folders, Array))
            pathArray = pathArray.concat(cast folders);
        else
            throw '${Type.getClass(folders)} data is not allowed';


        for(folder in pathArray)
        {
            if(!FileSystem.exists(folder))
                throw '${folder} directory not found';
        }

        var out:BytesOutput = new BytesOutput();
        var zip:Writer = new Writer(out);
        var zipEntries:List<Entry> = new List();
        for(folder in pathArray)
        {
            var folderEntries:List<Entry> = ZipUtils.getEntries(folder, entry -> {
                entry.data = haxe.zip.Compress.run(entry.data, 9);
                entry.compressed = true;
            });
            for(folderEntry in folderEntries)
            {
                zipEntries.push(folderEntry);
            }
        }

        zip.write(zipEntries);

        var hash = getHashOfDirectory(zipEntries);
        var fields:Array<Field> = Context.getBuildFields();
        #if orbis
        var bytesField:Field = fields.getFieldOrFail(fieldData.bytesField);
        var bytes:Bytes = out.getBytes();

        var bytesBase64:String = Base64.encode(bytes);
        bytesField.kind = FieldType.FVar(macro:String, macro $v{bytesBase64});

        var hashField = fields.getFieldOrFail(fieldData.hashField);
        hashField.kind = FieldType.FVar(macro:String, macro $v{hash});
        #else
        Context.addResource("resource.data", out.getBytes());
        Context.addResource("resource.hash", Bytes.ofString(hash));
        #end

        return fields;
    }

    private static function getHashOfDirectory(entries:List<Entry>):String {
        var hashPool:String = "";
        for(entry in entries) {
            hashPool += Md5.make(entry.data).toHex();
        }
        return Md5.encode(hashPool);
    }
}
