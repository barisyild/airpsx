package airpsx.type;
enum abstract DatabaseType(String) from String to String {
    var DEFAULT = "default";
    var TASK = "task";
    var APP = "app";
}