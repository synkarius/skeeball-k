package systems.debug;

import h3d.mat.Texture;
import h3d.mat.Material;
import h3d.prim.Cube;
import h3d.scene.Mesh;
import oimo.common.Vec3;
import sys.io.File;
import resources.Constants;
import game.ui.ControlMode;
import game.data.GameData;
import h3d.scene.Scene;
import hxd.Key;

class InputDebugSystem implements System {

    private final getGameData: Void -> GameData;
    private final s3d:Scene;
    private var val1:Float;
    private var val2:Float;
    private var val3:Float;
    private final controlModes:Array<ControlMode>;
    private var i:Int;
    private var positioningCube:Mesh;

    public function new(s3d:Scene, getGameData: Void -> GameData) {
        this.s3d = s3d;
        this.getGameData = getGameData;

        this.val1 = 0;
        this.val2 = 0;
        this.val3 = 0;
        this.controlModes = [
            Title,
            SelectPosition,
            SelectAngle,
            SelectPower,
            BallIsMoving,
            AskNewGame
        ];
    }

    public function update(dt:Float):Void {
        final unit:Float = 0.01;
        final trigger:(Int)->Bool = Key.isDown;

        if (trigger(Key.Y)) {
            this.setValueAndThenReportValues(unit, 0, 0);
        } else if (trigger(Key.H)) {
            this.setValueAndThenReportValues(-unit, 0, 0);
        } else if (trigger(Key.U)) {
            this.setValueAndThenReportValues(0, unit, 0);
        } else if (trigger(Key.J)) {
            this.setValueAndThenReportValues(0, -unit, 0);
        } else if (trigger(Key.I)) {
            this.setValueAndThenReportValues(0, 0, unit);
        } else if (trigger(Key.K)) {
            this.setValueAndThenReportValues(0, 0, -unit);
        } else if (trigger(Key.O)) {
            final gameData:GameData = this.getGameData();
            gameData.getMutableState().setHasBeenFired(true);
            gameData.getMutableState().setControlMode(BallIsMoving);
            
            final file = File.read("value.txt", false);
            final line = file.readLine();
            final x = Std.parseFloat(line);
            gameData.getBall().getPhysicsEntity().getRigidBody().setLinearVelocity(new Vec3(-1.8, 0, 0));
            gameData.getBall().getPhysicsEntity().getRigidBody().setPosition(new Vec3(x, 2.0, 0.));

        } else if (trigger(Key.L)) {
            final gameData:GameData = this.getGameData();
            gameData.getMutableState().setScore(gameData.getMutableState().getScore() + 1);
        } else if (trigger(Key.P)) {
            // this.setValueAndThenReportValues(0, 0, unit);
        } else if (trigger(Key.QWERTY_SEMICOLON)) {
            // this.setValueAndThenReportValues(0, 0, -unit);
        }
    }

    private function setValueAndThenReportValues(val1:Float, val2:Float, val3:Float):Void {
        this.val1 += val1;
        this.val2 += val2;
        this.val3 += val3;

        final gameData:GameData = this.getGameData();
        
        this.movePositioningCube();

        trace("" + this.val1 + ", " + this.val2 + ", " + this.val3); 
    }

    private function movePositioningCube() {
        if (this.positioningCube == null) {
            final prim:Cube = new Cube(.1, .1, .1, true);
            prim.addNormals();
            prim.addUVs();
            // still works even if the cube is invisible and behind another mesh
            this.positioningCube = new Mesh(prim, Material.create(Texture.fromColor(0xbf0000)));
            this.s3d.addChild(this.positioningCube);
        }
        
        this.positioningCube.setPosition(this.val1, this.val2, this.val3);
    }
}