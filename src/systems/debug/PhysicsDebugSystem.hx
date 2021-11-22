package systems;

import game.data.GameData;
import oimo.common.Vec3;
import physics.entities.MovablePolygonalPhysicsEntity;
import physics.entities.PhysicsEntity;
import physics.entities.SimplePhysicsEntity;
import h3d.scene.Mesh;
import h3d.prim.Polygon;

@:deprecated
class PhysicsDebugSystem implements System {

    private final getGameData: Void -> GameData;

    public function new(getGameData: Void -> GameData){
        this.getGameData = getGameData;
    }

    public function update(dt:Float):Void {}

    /**
     * Update all vertices of mesh, based on vertices of rigid body. 
     * 
     * Then remove and add from scene to apply changes.
     * @param entity 
     */
    private function updateMovablePolygonalPhysicsEntity(entity:MovablePolygonalPhysicsEntity, s3d:h3d.scene.Scene):Void {
        final debugMesh:Mesh = entity.getDebugMesh();
        // TODO: need the mesh/rigidBody vertices map implemented
        // final primitive:Polygon = cast (debugMesh.primitive, Polygon);
        // primitive.points[0].set(primitive.points[0].x, primitive.points[0].y, primitive.points[0].z+.001);
        s3d.removeChild(debugMesh);
        s3d.addChild(debugMesh);
    }

    
}