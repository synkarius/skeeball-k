package resources.parsers;

import resources.parsers.structures.Vertex;
import h3d.prim.Polygon;
import h3d.col.Point;
import oimo.dynamics.rigidbody.Shape;
import oimo.dynamics.rigidbody.RigidBodyType;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import oimo.dynamics.rigidbody.ShapeConfig;
import oimo.collision.geometry.Geometry;
import oimo.common.Vec3;
import hxd.res.Resource;
import physics.entities.SimplePhysicsEntity;
import h3d.scene.Mesh;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.collision.geometry.ConvexHullGeometry;
import physics.entities.PhysicsEntity;
using Lambda;

class PhysicsOBJParser extends BaseOBJParser implements PhysicsParser {

    public function parse(resource:Resource):PhysicsEntity {
        final lines:Array<String> = this.getLines(resource);
        final vertices:Array<Vertex> = this.getVertices(lines);
        final vec3s:Array<Vec3> = vertices.map(v -> new Vec3(v.getX(), v.getY(), v.getZ()));

        final convexHullGeometry:ConvexHullGeometry = new ConvexHullGeometry(vec3s);
        final rigidBody:RigidBody = this.mapGeometryToRigidBody(convexHullGeometry);

        final debugMesh:Mesh = this.getMesh(lines, vertices);
        
        return new SimplePhysicsEntity(rigidBody, debugMesh);
    }

    private function getMesh(lines:Array<String>, vertices:Array<Vertex>):Mesh {
        final pointsOfFaceTriplets:Array<Point> = this.getFaces(lines, vertices);
        return this.mapPointsToMesh(pointsOfFaceTriplets);
    }

    private function mapPointsToMesh(points:Array<Point>):Mesh {
        final primitive:Polygon = new Polygon(points);
        primitive.unindex(); // unindex the faces to create hard edges normals
        primitive.addNormals(); // add face normals
        final mesh:Mesh = new Mesh(primitive);
        mesh.material.color.setColor(0xFFB280); // set the polygon color #727272 -> metal gray
        mesh.material.shadows = false;
        return mesh;
    }

    private function getFaces(lines:Array<String>, vertices:Array<Vertex>):Array<Point> {
        return lines.filter(line -> line.indexOf("f ") == 0)
            .map(f -> f.split("f ")[1])
            .map(f -> f.split(" "))
            .map(f -> f.map(v -> v.split("/")[0]))
            .map(f -> f.map(Std.parseInt))
            .flatten()
            .map(vi -> vertices[vi - 1])
            .map(v -> new Point(v.getX(), v.getY(), v.getZ()));
    }

    private function mapGeometryToRigidBody(geom:Geometry):RigidBody {
        final shapeConfig:ShapeConfig = new ShapeConfig();
		shapeConfig.geometry = geom;
		final bodyConfig:RigidBodyConfig = new RigidBodyConfig();
		bodyConfig.type = RigidBodyType.STATIC;
        // obj format has world coords -- this won't work well for rotation, but none of these need to be rotated, so it's fine
		bodyConfig.position = new Vec3(0, 0, 0);
		final body:RigidBody = new RigidBody(bodyConfig);
		body.addShape(new Shape(shapeConfig));
		return body;
    }

    private function createHullToMeshIndicesMap(independentVertices:Array<Vertex>, faceVertices:Array<Point>):Map<Int, Array<Int>> {
        /*
         * TODO: this, if you ever create a game with convex hulls that move where you need to implement `DebugDraw`.
         * See `OHPolygonPhysicsEntity` for more notes.
         */ 
        return null;
    } 
}