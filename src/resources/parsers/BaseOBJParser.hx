package resources.parsers;

import h3d.prim.UV;
import h3d.col.Point;
import hxd.res.Resource;
import resources.parsers.structures.Vertex;
using Lambda;

typedef OBJFace = {        // are these triplets how the indexing works?
    final vertices:Array<Point>;    // should be 3 points [x1,y1,z1], [x2,y2,z2], [x3,y3,z3]
    final uvs:Array<UV>;            // should be 3 uvs    [x1,y1],    [x2,y2],    [x3,y3]
    final normals:Array<Point>;     // should be 3 points [x1,y1,z1], [x2,y2,z2], [x3,y3,z3]
}

/**
 * Parses the Wavefront OBJ format.
 * <br>
 * - Heaps.io reads vertices as vertex triplets representing triangle faces. 
 *      Therefore, Heap's h3d needs some vertices listed multiple times.
 * - Oimophysics constructs a convex hull out of the nonrepeating total list of indices.
 */
class BaseOBJParser {

    public function new() {}

    private function getLines(resource:Resource):Array<String> {
        final text:String = resource.entry.getText();
        final cleaned:String = StringTools.replace(text, "\r", "");
        return cleaned.split("\n");
    }

    /**
     * The vertex returned from this function is an array of 3 floats: [x,y,z]
     * @param lines 
     * @return Array<Vec3>
     */
    private function getVertices(lines:Array<String>):Array<Vertex> {
        return lines.filter(line -> line.indexOf("v ") == 0)
            .map(v -> v.split("v ")[1])
            .map(v -> v.split(" "))
            .map(v -> v.map(Std.parseFloat))
            .map(v -> new Vertex(v[0], v[1], v[2]));
    }

    
}