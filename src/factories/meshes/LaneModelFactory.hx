package factories.meshes;

import h3d.mat.Material;
import h3d.mat.Texture;
import hxd.Res;
import resources.parsers.MeshParser;
import h3d.scene.Mesh;

interface LaneModelFactory {
    
    public function createLane():Mesh;
}

class SimpleModelLaneFactory implements LaneModelFactory {

    final meshParser:MeshParser;

    public function new(meshParser:MeshParser) {
        this.meshParser = meshParser;
    }

    public function createLane():Mesh {
        final mesh:Mesh = this.meshParser.parse(Res.display.model_lane, UseMaterial(true));

        final texture:Texture = Res.textures.skeeball_machine_texture.toTexture();
        final material:Material = Material.create(texture);
        mesh.material = material;
        mesh.material.shadows = true;
        mesh.material.castShadows = true;

        return mesh;
    }
}