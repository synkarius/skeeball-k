package factories.meshes;

import resources.parsers.MeshParser;
import h3d.scene.Mesh;
import h3d.mat.Texture;
import hxd.Res;
import h3d.mat.Material;

interface PlaneFactory {

    public function createPlane():Mesh;
}

class SimplePlaneFactory implements PlaneFactory {

    private final meshParser:MeshParser;

    public function new(meshParser:MeshParser) {
        this.meshParser = meshParser;
    }

    public function createPlane():Mesh {
        final mesh:Mesh = this.meshParser.parse(Res.display.plane, UseMaterial(true));

        final texture:Texture = Res.textures.floor_wall_diffuse_map.toTexture();
        final normalMap:Texture = Res.textures.floor_wall_normal_map.toTexture();
        final material:Material = Material.create(texture);
        mesh.material = material;
        mesh.material.normalMap = normalMap;
        mesh.material.shadows = false;
        mesh.material.specularAmount = 0.5;
        // mesh.material.specularPower = 0.5;

        return mesh;
    }
}