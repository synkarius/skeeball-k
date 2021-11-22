package systems;

import game.data.GameData;

/**
 * Called 1x/frame, after all other systems. 
 * Responsible for:
 * - updating gameData's double buffer
 */
class StateSyncSystem implements System {

    private final getGameData: Void -> GameData;

    public function new(getGameData: Void -> GameData){
        this.getGameData = getGameData;
    }

    public function update(dt:Float):Void {
        final gameData:GameData = this.getGameData();
        gameData.getMutableState().copyCurrentToLast();
    }
}