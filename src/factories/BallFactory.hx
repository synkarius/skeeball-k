package factories;

import factories.meshes.ArrowModelFactory;
import h3d.scene.Object;
import resources.Constants;
import physics.entities.PhysicsEntity;
import game.data.Ball;
import factories.SpherePhysicsEntityFactory;
import h3d.mat.Material;
import h3d.mat.Texture;
import hxd.Res;
import h3d.prim.Sphere;
import h3d.scene.Mesh;

class BallFactory {

    private final spherePhysicsEntityFactory:SpherePhysicsEntityFactory;
    private final arrowModelFactory:ArrowModelFactory;

    public function new(
            spherePhysicsEntityFactory:SpherePhysicsEntityFactory,
            arrowModelFactory:ArrowModelFactory) {
        this.spherePhysicsEntityFactory = spherePhysicsEntityFactory;
        this.arrowModelFactory = arrowModelFactory;
    }

    public extern inline overload function createBall():Ball {
        return this.createBall(
            Constants.BALL_RADIUS, 
            Constants.BALL_X, 
            Constants.BALL_Y,
            Constants.BALL_Z);
    }

    public extern inline overload function createBall(radius:Float, px:Float, py:Float, pz:Float):Ball {
        // physics entity: moves around in the physics world; heaps.io mesh position mirrors physics world position
        final physicsEntity:PhysicsEntity = this.spherePhysicsEntityFactory.createSphere(radius, px, py, pz);
        // ball mesh
        final ballMesh:Mesh = this.createMesh(radius);
        // arrow mesh for angle setting control mode
        final arrowMesh:Mesh = this.arrowModelFactory.createArrow();
        // arrow mesh relative position inside arrow container
        arrowMesh.x = Constants.ARROW_MODEL_X;
        arrowMesh.y = Constants.ARROW_MODEL_Y;
        // arrow container
        final arrowContainer:Object = new Object();
        arrowContainer.addChild(arrowMesh);
        arrowContainer.visible = false;
        //
        final container:Object = new Object();
        container.setPosition(px, py, pz);
        container.addChild(ballMesh);
        container.addChild(arrowContainer);

        return new Ball(physicsEntity, container, arrowContainer);
    }

    private function createMesh(radius:Float):Mesh {
        final primitive:Sphere = new Sphere(radius);
        primitive.addNormals();
        primitive.addUVs();
        final mesh:Mesh = new Mesh(primitive);
        final texture:Texture = Res.textures.ball.toTexture();
        final material:Material = Material.create(texture);
        mesh.material = material;
        mesh.material.shadows = true;
        mesh.material.castShadows = true;
        
        return mesh;
    }
}