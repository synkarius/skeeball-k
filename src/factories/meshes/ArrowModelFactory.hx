package factories.meshes;

import resources.Constants;
import resources.parsers.MeshParser;
import h3d.scene.Mesh;
import hxd.Res;

interface ArrowModelFactory {
    
    public function createArrow():Mesh;
}

class SimpleArrowModelFactory implements ArrowModelFactory {

    final meshParser:MeshParser;

    public function new(meshParser:MeshParser) {
        this.meshParser = meshParser;
    }

    public function createArrow():Mesh {
        final mesh:Mesh = this.meshParser.parse(Res.display.arrow, UseMaterial(false));
        mesh.material.color.setColor(Constants.COLOR_ORANGE);
        mesh.material.shadows = false;
        mesh.scale(Constants.ARROW_MODEL_SCALE);
        return mesh;
    }
}