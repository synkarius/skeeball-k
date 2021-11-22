package systems;

import resources.Constants;
import game.data.mutable.tweens.PowerBarHeight;
import game.ui.PowerBar;
import h2d.col.Point;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.common.Vec3;
import hxd.Window;
import hxd.Event;
import hxd.Key;
import game.data.GameData;

/**
 * Responsible for:
 * - altering GameData in response to player input in various modes
 * - recording the player's selected inputs
 */
class InputSystem implements System {

    private final getGameData: Void -> GameData;
    /* save allocations / GC */
    private final tempVector:Vec3;
    private final tempPoint:Point;

    public function new(getGameData: Void -> GameData){
        this.getGameData = getGameData;
        this.tempVector = new Vec3();
        this.tempPoint = new Point();
        Window.getInstance().addEventTarget(this.updateMouseEvents);
    }

    public function update(dt:Float):Void {
        final gameData:GameData = this.getGameData();

        switch (gameData.getMutableState().getControlMode()) {
            case Title: this.startNewGameOnEnterKeyFromTitleScreen();
            case SelectPosition: this.clickToSelectPosition();
            case SelectAngle: this.clickToSelectAngle();
            case SelectPower: this.clickToSelectPower();
            case AskNewGame: this.startNewGameOnEnterKeyFromAskNewGameScreen();
            default: false; // pass
        }

        gameData.getMutableState().setMouseWasClicked(false);
    }

    private function startNewGameOnEnterKeyFromAskNewGameScreen():Void {
        if (Key.isPressed(Key.ENTER)) {
            final gameData:GameData = this.getGameData();
            gameData.getMutableState().setResetRequest(true);
        }
    }

    private function startNewGameOnEnterKeyFromTitleScreen():Void {
        if (Key.isPressed(Key.ENTER)) {
            final gameData:GameData = this.getGameData();
            gameData.getMutableState().setControlMode(SelectPosition);
            gameData.getCameraPosition().frameCount = 0;
        }
    }

    private function clickToSelectPosition():Void {
        final gameData:GameData = this.getGameData();
        if (gameData.getMutableState().getMouseWasClicked()) {
            final position:Vec3 = gameData.getBall().getPhysicsEntity().getRigidBody().getPosition();
            gameData.getMutableState().setSelectedPosition(
                position.x,
                position.y,
                position.z);
            gameData.getMutableState().setControlMode(SelectAngle);
        }
    }

    private function clickToSelectAngle():Void {
        final gameData:GameData = this.getGameData();
        if (gameData.getMutableState().getMouseWasClicked()) {
            final angle:Point = this.tempPoint;
            util.WindowUtil.getBallAngleMut(angle);
            gameData.getMutableState().setSelectedAngle(angle);
            gameData.getPowerBar().getHeight().frameCount = Std.int(Math.random() * Constants.POWER_BAR_TOTAL_FRAMES); // randomize to prevent "saving" the last power
            gameData.getMutableState().setControlMode(SelectPower);
        }
    }

    private function clickToSelectPower():Void {
        final gameData:GameData = this.getGameData();
        if (gameData.getMutableState().getMouseWasClicked()) {
            final powerBar:PowerBar = gameData.getPowerBar();
            final powerBarHeight:PowerBarHeight = powerBar.getHeight();
            gameData.getMutableState().setSelectedPower(Math.abs(powerBarHeight.scaleY));
            gameData.getMutableState().setControlMode(BallIsMoving);
        }
    }

    private function updateMouseEvents(event:Event):Void {
        // if the mouse was clicked at all, anywhere, that's all we want to know here
        if (event.kind == ERelease) {
            this.getGameData().getMutableState().setMouseWasClicked(true);
        }
    }
 }