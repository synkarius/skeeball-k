package physics.entities;

import oimo.dynamics.rigidbody.RigidBody;
import h3d.scene.Mesh;

/**
 * Oimophysics/Heaps.io Convex Polygon Physics Entity
 */
class MovablePolygonalPhysicsEntity extends SimplePhysicsEntity {

    /**
     * The structure of this map is:
     * ###############################
     * {rigid-body-vert-index: [
     *      matching-mesh-index-1,
     *      matching-mesh-index-2 ...
     * ]}
     * ###############################
     * The reason we want to have this map is to that when the physics engine alters a RigidBody vertex,
     * the change can be copied to ALL of the corresponding Mesh indices. (Unfortunately, these are not 1:1
     * between oimophysics and heaps.io.)
     * 
     * This is really only necessary for non-spherical shapes. With a sphere, you can just use the center
     * and radius.
     */
    private final rigidBodyToMeshIndicesMap:Map<Int, Array<Int>>;

    public function new(
            rigidBody:RigidBody, 
            debugMesh:Mesh,
            rigidBodyToMeshIndicesMap:Map<Int, Array<Int>>) {
        super(rigidBody, debugMesh);
        this.rigidBodyToMeshIndicesMap = rigidBodyToMeshIndicesMap;
    }

    public function getRigidBodyToMeshIndicesMap():Map<Int, Array<Int>> {
        return this.rigidBodyToMeshIndicesMap;
    }
}