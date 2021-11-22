package collections;

import haxe.ds.HashMap;

@:generic
class HashSet<T:{function hashCode():Int;}> {

    private final backingMap:HashMap<T, Bool>;
    
    public function new() {
        this.backingMap = new HashMap<T, Bool>();
    }

    public function add(t:T):Void {
        this.backingMap.set(t, true);
    }

    public function remove(t:T):Void {
        this.backingMap.remove(t);
    }

    public function contains(t:T):Bool {
        return this.backingMap.exists(t);
    }

    public function clear():Void {
        this.backingMap.clear();
    }
}