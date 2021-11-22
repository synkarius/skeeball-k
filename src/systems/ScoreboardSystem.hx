package systems;

import h3d.mat.Material;
import factories.DigitMaterialsFactory;
import game.data.Scoreboard;
import game.data.GameData;

/**
 * Responsible for:
 * - reskinning the scoreboards to reflect the player's score
 * - resetting the scoreboards at the beginning of the game
 */
class ScoreboardSystem implements System {

    private final getGameData: Void -> GameData;
    private final digitMaterialsFactory:DigitMaterialsFactory;
    private var digitMaterials:Array<Material>;

    public function new(
            getGameData: Void -> GameData,
            digitMaterialsFactory:DigitMaterialsFactory){
        this.getGameData = getGameData;
        this.digitMaterialsFactory = digitMaterialsFactory;
    }

    public function update(dt:Float):Void {
        if (this.digitMaterials == null) {
            this.digitMaterials = [for (i in 0...10) digitMaterialsFactory.createDigitMaterial(i)];
        }

        final gameData:GameData = this.getGameData();

        if (gameData.scoreChanged()) {
            final score:Int = gameData.getMutableState().getScore();
            final onesDigit:Int = score % 10;
            final tensDigit:Int = Std.int(((score - onesDigit) % 100) / 10);
            final hundredsDigit:Int = Std.int((score - tensDigit - onesDigit) / 100);
            
            final scoreboard:Scoreboard = gameData.getScoreboard();
            scoreboard.getOnes().material = this.digitMaterials[onesDigit];
            scoreboard.getTens().material = this.digitMaterials[tensDigit];
            scoreboard.getHundreds().material = this.digitMaterials[hundredsDigit];
        }
    }
}