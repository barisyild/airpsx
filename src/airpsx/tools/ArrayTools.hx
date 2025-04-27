package airpsx.tools;
class ArrayTools {
    public static function randomElement<T>(array:Array<T>):T {
        return array[Std.random(array.length)];
    }
}