package factories;

import h3d.mat.Texture;
import h3d.mat.Material;
import hxd.Res;

interface DigitMaterialsFactory {
    public function createDigitMaterial(digit:Int):Material;
}

class CachedDigitMaterialsFactory implements DigitMaterialsFactory {

    private var digitTextures:Array<Texture>;

    public function new() {}

    public function createDigitMaterial(digit:Int):Material {
        if (this.digitTextures == null) {
            this.digitTextures = this.createDigitalTexturesArray();
        }

        final material:Material = Material.create(this.digitTextures[digit]);
        material.shadows = false;
        return material;
    }

    private function createDigitalTexturesArray():Array<Texture> {
        return [
            Res.textures.digits.score_0,
            Res.textures.digits.score_1,
            Res.textures.digits.score_2,
            Res.textures.digits.score_3,
            Res.textures.digits.score_4,
            Res.textures.digits.score_5,
            Res.textures.digits.score_6,
            Res.textures.digits.score_7,
            Res.textures.digits.score_8,
            Res.textures.digits.score_9
        ]
        .map(image -> image.toTexture());
    }
}