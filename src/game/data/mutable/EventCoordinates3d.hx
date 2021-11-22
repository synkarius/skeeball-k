package game.data.mutable;

import hxd.Event;
import h3d.col.Point;

abstract EventCoordinates3d(Point) {

    inline public function new(point:Point) {
        this = point;
    }

    public function updateFromEvent(event:Event):Void {
        this.set(event.relX, event.relY, event.relZ);
    }

    public function getX() {
        return this.x;
    }

    public function getY() {
        return this.y;
    }

    public function getZ() {
        return this.z;
    }
}