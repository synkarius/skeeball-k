package physics;

import physics.entities.PhysicsEntity;
import physics.entities.SimplePhysicsEntity;
import h3d.prim.Sphere;
import h3d.scene.Mesh;
import oimo.collision.geometry.SphereGeometry;
import oimo.common.Vec3;
import oimo.dynamics.rigidbody.Shape;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.dynamics.rigidbody.RigidBodyType;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import oimo.dynamics.rigidbody.ShapeConfig;

class SpherePhysicsEntityFactory {

    public function new(){}

    /**
     * Creates a sphere physics entity.
     * @param radius radius
     * @param px position x
     * @param py position y
     * @param pz position z
     */
    public function createSphere(radius:Float, px:Float, py:Float, pz:Float):PhysicsEntity {
        final rigidBody:RigidBody = this.createRigidBody(radius, px, py, pz); 
        final mesh:Mesh = this.createMesh(radius, px, py, pz); 

        return new SimplePhysicsEntity(rigidBody, mesh);
    }

    private function createMesh(radius, px, py, pz) {
        final primitive = new Sphere(radius);
        primitive.unindex();
        primitive.addNormals();
        final mesh = new Mesh(primitive);
        mesh.material.color.setColor(0xFFB280); // set the polygon color
        mesh.material.shadows = false;
        mesh.setPosition(px, py, pz);
        return mesh;
    }

    private function createRigidBody(radius:Float, px:Float, py:Float, pz:Float):RigidBody {
        final shapeConfig:ShapeConfig = new ShapeConfig();
		shapeConfig.geometry = new SphereGeometry(radius);
		final bodyConfig:RigidBodyConfig = new RigidBodyConfig();
		bodyConfig.type = RigidBodyType.DYNAMIC;
		bodyConfig.position = new Vec3(px, py, pz);
		final body:RigidBody = new RigidBody(bodyConfig);
		body.addShape(new Shape(shapeConfig));
        return body;
    }
}