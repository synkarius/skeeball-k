package game.data;

import game.ui.AskNewGameOverlay;
import util.MathUtil;
import game.data.mutable.tweens.CameraPosition;
import game.data.mutable.EventCoordinates3d;
import game.data.mutable.MutableGameState.DoubleBufferedMutableGameState;
import game.ui.BallsRemainingCounter;
import game.ui.PowerBar;
import game.ui.TitleScreenOverlay;
import game.data.Ball;
import oimo.dynamics.World;

/**
 * This is all the stuff that the ECS-like "systems" need access to.
 * Since there is only one of everything, it doesn't make much sense to 
 * use proper ECS though.
 */
@:build(macros.RecordClassMacro.Record.build())
class GameData {    
    /* oimo: physics */
    var physicsWorld:World;
    var ball:Ball;
    
    /* ui */
    var titleScreenOverlay:TitleScreenOverlay;
    var askNewGameOverlay:AskNewGameOverlay;
    var cameraPosition:CameraPosition;
    var powerBar:PowerBar;
    var ballsRemainingCounter:BallsRemainingCounter;
    var scoreboard:Scoreboard;

    /* control: player inputs, player-visible data, internal control mechanisms */
    var mouseMove3dCoordinates:EventCoordinates3d;    
    var mutableState:DoubleBufferedMutableGameState;

    public function controlModeChanged():Bool {
        return this.mutableState.getControlMode() != this.mutableState.getLastFrameControlMode();
    }

    public function scoreChanged():Bool {
        return this.mutableState.getScore() != this.mutableState.getLastFrameScore();
    }

    public function decrementBallsRemaining():Void {
        this.mutableState.setBallsRemaining(MathUtil.max(0, this.mutableState.getBallsRemaining() - 1));
    }

    public function ballsRemainingChanged() {
        return this.mutableState.getBallsRemaining() != this.mutableState.getLastFrameBallsRemaining();
    }

    public function addToScore(points:Int):Void {
        this.mutableState.setScore(this.mutableState.getScore() + points);
    }
}