package game.data.mutable.tweens;

import resources.Constants;

class PowerBarHeight {

    public var scaleY:Float;
    public var frameCount:Int;

    public function new() {
        this.scaleY = -1.;
        this.frameCount = Constants.POWER_BAR_TOTAL_FRAMES;
    }
}