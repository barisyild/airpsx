package tools;

class ArrayFilterTools {

    //TODO: optimize
    public static inline function filterLimit<T>(array:Array<T>, limit:Int, f:T->Bool):Array<T>
    {
        var array:Array<T> = array.filter(f);

        if(array == null)
            return null; //There is no result!

        array.resize(limit);

        return array;
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
