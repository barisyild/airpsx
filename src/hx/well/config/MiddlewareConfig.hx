package hx.well.config;
import hx.well.middleware.DatabaseMiddleware;
import hx.well.middleware.AbstractMiddleware;
import hx.well.middleware.DebugMiddleware;

class MiddlewareConfig implements IConfig {
    public function new() {}

    public function get():Array<Class<AbstractMiddleware>> {
        return [
            DebugMiddleware,
            DatabaseMiddleware
        ];
    }
}