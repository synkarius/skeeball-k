package systems;

import game.data.GameData;

class PhysicsSystem implements System {

    private final getGameData: Void -> GameData;

    public function new(getGameData: Void -> GameData){
        this.getGameData = getGameData;
    }

    public function update(dt:Float):Void {
        final gameData:GameData = this.getGameData();
        gameData.getPhysicsWorld().step(dt);
    }
}