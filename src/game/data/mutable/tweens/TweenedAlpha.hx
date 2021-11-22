package game.data.mutable.tweens;

class TweenedAlpha {

    public var alpha:Float;
    public var frameCount:Int;

    public function new(initialAlpha:Float, initialFrameCount:Int) {
        this.alpha = initialAlpha;
        this.frameCount = initialFrameCount;
    }
}