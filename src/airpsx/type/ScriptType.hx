package airpsx.type;

enum abstract ScriptType(String) from String to String {
    var RULESCRIPT = "rulescript";
    var LUA = "lua";
}