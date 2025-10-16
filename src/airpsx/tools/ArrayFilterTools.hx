package airpsx.tools;

class ArrayFilterTools {

    public static inline function filterLimit<T>(array:Array<T>, limit:Int, f:T->Bool):Array<T>
    {
        return array.filter(f).slice(0, limit);
    }

    public static inline function filterOne<T>(array:Array<T>, f:T->Bool):Null<T>
    {
        var result:T = null;

        for(item in array)
        {
            if(f(item))
            {
                result = item;
                break;
            }
        }

        return result;
    }
}
