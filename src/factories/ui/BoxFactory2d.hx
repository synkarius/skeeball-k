package factories.ui;

import h2d.Graphics;

class BoxFactory2d {
    
    public function new() {}

    public function createBox2d(
            x:Float, 
            y:Float, 
            w:Float, 
            h:Float,
            color:Int):Graphics {
        final rectangle:Graphics = new Graphics();
        rectangle.beginFill(color);
        rectangle.drawRect(x, y, w, h);
        rectangle.endFill();
        return rectangle;
    }
}