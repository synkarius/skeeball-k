package resources.parsers;

import hxd.res.Resource;
import h3d.scene.Mesh;

interface MeshParser {
    public function parse(resource:Resource, ...parseOptions:ParserOption):Mesh;
}