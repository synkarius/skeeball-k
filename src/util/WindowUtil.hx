package util;

import h2d.col.Point;

class WindowUtil {

    public static inline function getBallAngle():Point {
        final pMut:Point = new Point();
        getBallAngleMut(pMut);
        return pMut;
    }

    public static inline function getBallAngleMut(pMut:Point):Void {
        final window:hxd.Window = hxd.Window.getInstance();

        final originX:Float = window.width / 2;
        final originY:Float = window.height;

        final deltaX:Float = originX - window.mouseX;
        final deltaY:Float = originY - window.mouseY;

        pMut.x = deltaX;
        pMut.y = deltaY;
    }
}