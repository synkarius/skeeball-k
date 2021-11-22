package resources.parsers;

import resources.caching.ResourceCache;
import resources.parsers.structures.Vertex;
import resources.parsers.BaseOBJParser.OBJFace;
import h3d.prim.Polygon;
import h3d.col.Point;
import h3d.prim.UV;
import h3d.scene.Mesh;
import hxd.res.Resource;
import h3d.prim.Primitive;
using Lambda;

class MeshOBJParser extends BaseOBJParser implements MeshParser {

    private final primitiveCache:ResourceCache<ParserOption, Primitive>;

    public function new() {
        super();
        this.primitiveCache = new ResourceCache<ParserOption, Primitive>();
    }

    public function parse(resource:Resource, ...parserOptions:ParserOption):Mesh {
        final key:CacheKey<ParserOption> = NameAndOptions(resource.name, parserOptions);
        final primitive:Primitive = switch (this.primitiveCache.get(key)) {
            case Some(prim): prim;
            case None: this.getPrimitive(resource, parserOptions);
        };
        this.primitiveCache.set(key, primitive);

        return new Mesh(primitive);
    }

    private function getPrimitive(resource:Resource, parserOptions:Array<ParserOption>):Primitive {
        final lines:Array<String> = this.getLines(resource);
        final unindexedVertices:Array<Vertex> = this.getVertices(lines);
        final unindexedUVs:Array<UV> = this.getUVs(lines);
        final faces:Array<OBJFace> = this.getFaces(lines, unindexedVertices, unindexedUVs);
        final vertices:Array<Point> = faces.map(f -> f.vertices).flatten();
        final uvs:Array<UV> = faces.map(f -> f.uvs).flatten();

        final primitive:Polygon = new Polygon(vertices);

        // if this gets any more complex, consider using delegates
        if (parserOptions.exists(item -> item.match(UseMaterial(true)))) {
            primitive.uvs = uvs;
            primitive.addTangents();
        } else {
            primitive.unindex();
            primitive.addTangents();
        }

        return primitive;
    }

    /**
     * Returns a series of points. Each triplet of 3 points is a face.
     * @param lines 
     * @param vertices 
     * @return Array<Point>
     */
     private function getFaces(lines:Array<String>, vertices:Array<Vertex>, uvs:Array<UV>):Array<OBJFace> {
        return lines.filter(line -> line.indexOf("f ") == 0)
            .map(f -> f.split("f ")[1])
            .map(f -> f.split(" "))
            .map(f -> f.map(v -> v.split("/")))
            .map(f -> this.mapFace(f, vertices, uvs));
    }

    private function mapFace(f:Array<Array<String>>, vertices:Array<Vertex>, uvs:Array<UV>):OBJFace {
        return {
            vertices: [f[0][0], f[1][0], f[2][0]]
                .map(Std.parseInt)
                .map(vi -> vertices[vi - 1])
                .map(v -> new Point(v.getX(), v.getY(), v.getZ())),
            uvs: [f[0][1], f[1][1], f[2][1]]
                .map(Std.parseInt)
                .map(ui -> uvs[ui - 1]),
            normals: null
        }
    }

    /**
     * The uv returned from this function is an array of 2 floats: [x,y]
     * @param lines 
     * @return Array<UV>
     */
     private function getUVs(lines:Array<String>):Array<UV> {
        return lines.filter(line -> line.indexOf("vt ") == 0)
            .map(line -> line.split("vt ")[1])
            .map(uv -> uv.split(" "))
            .map(uv -> uv.map(Std.parseFloat))
            .map(uv -> new UV(uv[0], this.invert(uv[1])));
    }

    /**
     * Fixes UV values exported from Blender. There's some kind of format incompatibility.
     * @param value 
     * @return Float
     */
    private function invert(value:Float):Float {
        return Math.abs(1. - value);
    }
}