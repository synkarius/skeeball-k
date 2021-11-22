package game.data.mutable.tweens;

import resources.Constants;

class CameraPosition {

    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var frameCount:Int;

    public function new() {
        this.x = Constants.CAM_MENU_POSITION_X;
        this.y = Constants.CAM_MENU_POSITION_Y;
        this.z = Constants.CAM_MENU_POSITION_Z;
        this.frameCount = Constants.CAMERA_TRANSITION_TOTAL_FRAMES;
    }
}