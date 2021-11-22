package systems;

import game.data.GameData;

/**
 * Responsible for:
 * - switching visibility of 2d/3d UI components for different control modes
 */
class UiVisibilitySystem implements System {
    
    private final getGameData: Void -> GameData;

    public function new(getGameData: Void -> GameData){
        this.getGameData = getGameData;
    }

    public function update(dt:Float):Void {
        final gameData:GameData = this.getGameData();

        if (gameData.controlModeChanged()) {
            switch (gameData.getMutableState().getControlMode()) {
                case Title:
                    this.toggleTitleScreenVisibility(gameData, true);
                    this.toggleBallsRemainingCounterVisibility(gameData, false);
                case SelectPosition:
                    this.toggleBallsRemainingCounterVisibility(gameData, true);
                    this.toggleTitleScreenVisibility(gameData, false);
                    this.toggleAskNewGameVisibility(gameData, false);
                case SelectAngle:
                    this.toggleArrowVisibility(gameData, true);
                case SelectPower:
                    this.togglePowerBarVisibility(gameData, true);
                    this.toggleArrowVisibility(gameData, false);
                case BallIsMoving:
                    this.togglePowerBarVisibility(gameData, false);
                case AskNewGame:
                    this.toggleAskNewGameVisibility(gameData, true);
            }
        }
    }

    private function toggleTitleScreenVisibility(gameData:GameData, value:Bool):Void {
        gameData.getTitleScreenOverlay().getOverlayContainer().visible = value;
    }

    private function toggleBallsRemainingCounterVisibility(gameData:GameData, value:Bool):Void {
        gameData.getBallsRemainingCounter().getContainer().visible = value;
    }

    private function togglePowerBarVisibility(gameData:GameData, value:Bool):Void {
        gameData.getPowerBar().getContainer().visible = value;
    }

    private function toggleArrowVisibility(gameData:GameData, value:Bool):Void {
        gameData.getBall().getArrowContainer().visible = value;
    }

    private function toggleAskNewGameVisibility(gameData:GameData, value:Bool):Void {
        gameData.getAskNewGameOverlay().getOverlayContainer().visible = value;
    }
}

