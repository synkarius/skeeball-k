package factories;

import hxd.Res;
import resources.parsers.MeshParser;
import h3d.scene.Object;
import h3d.prim.Primitive;
import resources.Constants;
import h3d.col.Point;
import h3d.col.Bounds;
import h3d.mat.Material;
import h3d.scene.Mesh;
import game.data.Scoreboard;

interface ScoreboardFactory {
    public function createScoreboard():Scoreboard;
}

private enum DigitPosition {
    Left;
    Center;
    Right;
}

class SimpleScoreboardFactory implements ScoreboardFactory {

    private final meshParser:MeshParser;
    private final digitMaterialsFactory:DigitMaterialsFactory;
    private var primitive:Primitive;

    public function new(
            meshParser:MeshParser,
            digitMaterialsFactory:DigitMaterialsFactory) {
        this.meshParser = meshParser;
        this.digitMaterialsFactory = digitMaterialsFactory;
    }

    public function createScoreboard():Scoreboard {
        if (this.primitive == null) {
            this.primitive = this.createPlanePrimitive();
        }

        final hundreds:Mesh = this.createDigit(Left);
        final tens:Mesh = this.createDigit(Center);
        final ones:Mesh = this.createDigit(Right);
        
        final container:Object = new Object();
        container.addChild(hundreds);
        container.addChild(tens);
        container.addChild(ones);

        return new Scoreboard(container, hundreds, tens, ones);
    }

    private function createDigit(position:DigitPosition):Mesh {
        final zeroDigitMaterial:Material = this.digitMaterialsFactory.createDigitMaterial(0);
        final mesh:Mesh = new Mesh(this.primitive, zeroDigitMaterial);
        mesh.rotate(Math.PI/2, 0, 0);
        mesh.scale(Constants.SCOREBOARD_DIGIT_SCALE);
        // mesh.scaleX *= -1;
        this.setDigitPosition(mesh, position);
        return mesh;
    }

    private function setDigitPosition(digit:Mesh, position:DigitPosition) {
        final offset:Float = switch (position) {
            case Left: -1;
            case Center: 0;
            case Right: 1;
        };
        final bounds:Bounds = digit.getBounds();
        final size:Point = bounds.getSize();
        digit.setPosition(
            Constants.SCOREBOARD_DIGIT_X,
            Constants.SCOREBOARD_DIGIT_Y,
            // -size.z/ 2 + 
            size.z * offset);
    }

    private function createPlanePrimitive():Primitive {
        final mesh:Mesh = this.meshParser.parse(Res.display.plane, UseMaterial(true));
        return mesh.primitive;
    }
}