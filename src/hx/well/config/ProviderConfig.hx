package hx.well.config;
import hx.well.provider.BootProvider;
import hx.well.provider.AbstractProvider;
class ProviderConfig {
    public static function get():Array<Class<AbstractProvider>> {
        return [
            BootProvider
        ];
    }
}