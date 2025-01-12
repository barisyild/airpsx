package haxe.tar;

import haxe.tar.TarCompress;
import haxe.io.Output;

class StreamTarFile {
    private var folders:Array<String> = [];

    public function new() {

    }

    public function write(output:Output, next:Void->TarEntry):Void
    {
        var file:TarEntry = next();
        while (file != null)
        {
            TarCompress.createTarHeader(output, file.name, file.isDirectory, file.length);
            if(!file.isDirectory)
            {
                TarCompress.writeFileContent(output, file.input, file.length);
                file.input.close();
            }

            file = next();
        }

        for (i in 0...2) {
            output.write(TarCompress.PADDING_BYTES);
        }
    }
}
