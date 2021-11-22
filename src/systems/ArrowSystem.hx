package systems;

import h2d.col.Point;
import h3d.scene.Object;
import game.data.GameData;

/**
 * Responsible for:
 * - making the 3d arrow face the 2d cursor
 */
class ArrowSystem implements System {
    
    private final getGameData: Void -> GameData;
    // save on allocations / GC
    private final tempPoint:Point;

    public function new(getGameData: Void -> GameData){
        this.getGameData = getGameData;
        this.tempPoint = new Point();
    }

    public function update(dt:Float):Void {
        final gameData:GameData = this.getGameData();

        if (gameData.getMutableState().getControlMode() == SelectAngle) {
            this.makeArrowFaceCursor();
        }
    }

    private function makeArrowFaceCursor():Void {
        final gameData:GameData = this.getGameData();
        final arrowContainer:Object = gameData.getBall().getArrowContainer();

        util.WindowUtil.getBallAngleMut(this.tempPoint);
        final deltaX:Float = this.tempPoint.x;
        final deltaY:Float = this.tempPoint.y;

        final angleInRadians = hxd.Math.atan2(deltaY, deltaX) - hxd.Math.PI/2;
        arrowContainer.setRotation(0, angleInRadians, 0);
    }
}