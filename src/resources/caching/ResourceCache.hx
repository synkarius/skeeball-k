package resources.caching;

import haxe.ds.Option;

@:generic
enum CacheKey<K:EnumValue> {
    Name(name:String);
    NameAndOption(name:String, option:K);
    NameAndOptions(name:String, options:Array<K>);
}

@:generic
class ResourceCache<K:EnumValue, V> {

    private final cacheMap:Map<CacheKey<K>, V>;

    public function new() {
        this.cacheMap = new Map<CacheKey<K>, V>();
    }

    public function get(key:CacheKey<K>):Option<V> {
        final value = this.cacheMap.get(key);
        if (value == null) {
            return Option.None;
        }
        return Option.Some(value);
    }

    public function set(key:CacheKey<K>, value:V):Void {
        this.cacheMap.set(key, value);
    }
}