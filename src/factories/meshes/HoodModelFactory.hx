package factories.meshes;

import resources.Constants;
import resources.parsers.MeshParser;
import h3d.scene.Mesh;
import hxd.Res;

interface HoodModelFactory {
    
    public function createHood():Mesh;
}

class SimpleHoodModelFactory implements HoodModelFactory {

    final meshParser:MeshParser;

    public function new(meshParser:MeshParser) {
        this.meshParser = meshParser;
    }

    public function createHood():Mesh {
        final mesh:Mesh = this.meshParser.parse(Res.display.model_hood, UseMaterial(false));
        mesh.material.color.setColor(Constants.COLOR_GRAY);
        mesh.material.shadows = true;
        mesh.material.castShadows = false;
        return mesh;
    }
}