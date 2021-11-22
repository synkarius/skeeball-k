package physics.entities;

import h3d.scene.Mesh;
import oimo.dynamics.rigidbody.RigidBody;

class SimplePhysicsEntity implements PhysicsEntity {

    private final rigidBody:RigidBody;
    private final debugMesh:Mesh;

    public function new(rigidBody:RigidBody, debugMesh:Mesh) {
        this.rigidBody = rigidBody;
        this.debugMesh = debugMesh;
    }

    public function getRigidBody():RigidBody {
        return this.rigidBody;
    }

    public function getDebugMesh():Mesh {
        return this.debugMesh;
    }
}