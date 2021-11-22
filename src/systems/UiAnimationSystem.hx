package systems;

import game.ui.AskNewGameOverlay;
import h2d.Object;
import game.data.mutable.tweens.PowerBarHeight;
import game.ui.PowerBar;
import game.ui.TitleScreenOverlay;
import resources.Constants;
import game.data.mutable.tweens.TweenedAlpha;
import game.data.GameData;
using tweenxcore.Tools;

/**
 * Responsible for:
 * - moving the power bar up and down
 * - flashing the begin prompt
 * - setting the appropriate number of balls remaining
 */
class UiAnimationSystem implements System {

    private final getGameData: Void -> GameData;

    public function new(getGameData: Void -> GameData){
        this.getGameData = getGameData;
    }

    public function update(dt:Float):Void {
        final gameData:GameData = this.getGameData();

        switch (gameData.getMutableState().getControlMode()) {
            case Title: this.flashTheBeginPrompt();
            case SelectPower: this.adjustThePowerBar();
            case AskNewGame: this.fadeInNewGamePrompt();
            default: false; // pass
        }

        this.setBallsRemaining();
    }

    private function setBallsRemaining():Void {
        final gameData:GameData = this.getGameData();
        if (gameData.ballsRemainingChanged()) {
            final displayBalls:Array<Object> = gameData.getBallsRemainingCounter().getBalls();
            final ballsRemaining:Int = gameData.getMutableState().getBallsRemaining();
            for (i in 0...Constants.BRC_MAX_BALLS) {
                displayBalls[i].visible = i < ballsRemaining;
            }
        }
    }

    private function flashTheBeginPrompt():Void {
        final gameData:GameData = this.getGameData();
        final overlay:TitleScreenOverlay = gameData.getTitleScreenOverlay();
        final tweenTracker:TweenedAlpha = overlay.getPromptAlpha();

        final rate:Float = tweenTracker.frameCount / Constants.BEGIN_PROMPT_TOTAL_FRAMES;
        tweenTracker.alpha = rate.yoyo(Easing.sineInOut).lerp(0., 1.);
        overlay.getBeginPromptText().alpha = tweenTracker.alpha;

        // reset
        if (tweenTracker.frameCount++ > Constants.BEGIN_PROMPT_TOTAL_FRAMES) {
            tweenTracker.frameCount = 0;
        }
    }

    private function fadeInNewGamePrompt():Void {
        final gameData:GameData = this.getGameData();
        final overlay:AskNewGameOverlay = gameData.getAskNewGameOverlay();
        final tweenTracker:TweenedAlpha = overlay.getTextAlphaTween();

        if (tweenTracker.frameCount < Constants.NEW_GAME_PROMPT_TOTAL_FRAMES) {
            final rate:Float = tweenTracker.frameCount++ / Constants.NEW_GAME_PROMPT_TOTAL_FRAMES;
            tweenTracker.alpha = rate.quadIn().lerp(0., 1.);
            overlay.getOverlayContainer().alpha = tweenTracker.alpha;
        }
    }

    private function adjustThePowerBar():Void {
        final gameData:GameData = this.getGameData();
        final powerBar:PowerBar = gameData.getPowerBar();
        final powerBarHeight:PowerBarHeight = powerBar.getHeight();

        final rate:Float = powerBarHeight.frameCount / Constants.POWER_BAR_TOTAL_FRAMES;
        powerBarHeight.scaleY = rate.zigzag(Easing.linear).lerp(0., -1.);
        powerBar.getLevel().scaleY = powerBarHeight.scaleY;

        // reset
        if (powerBarHeight.frameCount++ > Constants.POWER_BAR_TOTAL_FRAMES) {
            powerBarHeight.frameCount = 0;
        }
    }
}