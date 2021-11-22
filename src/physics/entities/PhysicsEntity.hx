package physics.entities;

import h3d.scene.Mesh;
import oimo.dynamics.rigidbody.RigidBody;

interface PhysicsEntity {

    public function getRigidBody():RigidBody;

    public function getDebugMesh():Mesh;
}