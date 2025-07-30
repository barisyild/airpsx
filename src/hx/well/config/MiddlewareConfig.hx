package hx.well.config;
import hx.well.middleware.DatabaseMiddleware;
import hx.well.middleware.AbstractMiddleware;

class MiddlewareConfig {
    public static function get():Array<Class<AbstractMiddleware>> {
        return [
            DatabaseMiddleware
        ];
    }
}