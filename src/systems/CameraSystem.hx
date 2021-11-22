package systems;

import resources.Constants;
import h3d.Camera;
import game.data.mutable.tweens.CameraPosition;
import game.data.GameData;
using tweenxcore.Tools;

/**
 * Responsible for:
 * - moving the camera between the menu position and the play position
 */
class CameraSystem implements System {

    private final getGameData: Void -> GameData;
    private final camera3d:Camera;

    public function new(getGameData: Void -> GameData, camera3d:Camera){
        this.getGameData = getGameData;
        this.camera3d = camera3d;
    }

    public function update(dt:Float):Void {
        final cameraPosition:CameraPosition = this.getGameData().getCameraPosition();
        if (cameraPosition.frameCount < Constants.CAMERA_TRANSITION_TOTAL_FRAMES) {
            final rate:Float = cameraPosition.frameCount / Constants.CAMERA_TRANSITION_TOTAL_FRAMES;
            cameraPosition.x = rate.lerp(Constants.CAM_MENU_POSITION_X, Constants.CAM_PLAY_POSITION_X);
            cameraPosition.y = rate.lerp(Constants.CAM_MENU_POSITION_Y, Constants.CAM_PLAY_POSITION_Y);
            cameraPosition.z = rate.lerp(Constants.CAM_MENU_POSITION_Z, Constants.CAM_PLAY_POSITION_Z);

            camera3d.pos.set(cameraPosition.x, cameraPosition.y, cameraPosition.z);
            cameraPosition.frameCount++;
        }
    }
}