package systems;

import game.ui.AskNewGameOverlay;
import collections.HashSet;
import h3d.mat.Texture;
import h3d.mat.Material;
import h3d.prim.Cube;
import h3d.scene.Interactive;
import h3d.col.Point;
import game.data.mutable.EventCoordinates3d;
import game.data.mutable.MutableGameState.DoubleBufferedMutableGameState;
import game.data.mutable.tweens.CameraPosition;
import factories.ui.BallsRemainingCounterFactory;
import factories.ui.PowerBarFactory;
import game.ui.BallsRemainingCounter;
import game.ui.PowerBar;
import game.ui.TitleScreenOverlay;
import factories.ui.TitleScreenOverlayFactory;
import factories.ui.AskNewGameOverlayFactory;
import factories.ui.BoxFactory2d;
import h2d.Graphics;
import factories.meshes.PlaneFactory.PlaneFactory;
import game.data.Scoreboard;
import factories.ScoreboardFactory;
import h3d.scene.fwd.DirLight;
import resources.Constants;
import resources.PhysicsAssetDAO;
import factories.meshes.LaneModelFactory;
import factories.meshes.HoodModelFactory;
import factories.meshes.BoardModelFactory;
import game.data.GameData;
import physics.entities.PhysicsEntity;
import factories.BallFactory;
import game.data.Ball;
import h3d.scene.Mesh;
import h3d.Vector;
import hxd.Res;
using Lambda;

private typedef Screen2dItems = {
    final titleScreenOverlay:TitleScreenOverlay;
    final askNewGameOverlay:AskNewGameOverlay;
    final powerBar:PowerBar;
    final ballsRemaining:BallsRemainingCounter;
}

private typedef Screen3dItems = {
    final centerScoreboard:Scoreboard;
    final cameraPosition:CameraPosition;
}

class SetupSystem implements System {

    private final getGameData:Void -> GameData;
    private final setGameData:GameData -> Void;
    private final s2d:h2d.Scene;
    private final s3d:h3d.scene.Scene;
    private final physicsAssetDAO:PhysicsAssetDAO;
    private final boardFactory:BoardModelFactory;
    private final hoodFactory:HoodModelFactory;
    private final laneFactory:LaneModelFactory;
    private final scoreboardFactory:ScoreboardFactory;
    private final planeFactory:PlaneFactory;
    private final ballFactory:BallFactory;
    private final boxFactory2d:BoxFactory2d;
    private final titleScreenOverlayFactory:TitleScreenOverlayFactory;
    private final askNewGameOverlayFactory:AskNewGameOverlayFactory;
    private final powerBarFactory:PowerBarFactory;
    private final ballsRemainingCounterFactory:BallsRemainingCounterFactory;
    private final debugMode:Bool;
    

    public function new(
            getGameData:Void -> GameData,
            setGameData: GameData -> Void,
            s2d:h2d.Scene,
            s3d:h3d.scene.Scene,
            physicsAssetDAO:PhysicsAssetDAO,
            boardFactory:BoardModelFactory,
            hoodFactory:HoodModelFactory,
            laneFactory:LaneModelFactory,
            scoreboardFactory:ScoreboardFactory,
            planeFactory:PlaneFactory,
            ballFactory:BallFactory,
            boxFactory2d:BoxFactory2d,
            titleScreenOverlayFactory:TitleScreenOverlayFactory,
            askNewGameOverlayFactory:AskNewGameOverlayFactory,
            powerBarFactory:PowerBarFactory,
            ballsRemainingCounterFactory:BallsRemainingCounterFactory,
            debugMode:Bool) {
        this.getGameData = getGameData;
        this.setGameData = setGameData;
        this.s2d = s2d;
        this.s3d = s3d;
        this.physicsAssetDAO = physicsAssetDAO;
        this.boardFactory = boardFactory;
        this.hoodFactory = hoodFactory;
        this.laneFactory = laneFactory;
        this.scoreboardFactory = scoreboardFactory;
        this.planeFactory = planeFactory;
        this.ballFactory = ballFactory;
        this.boxFactory2d = boxFactory2d;
        this.titleScreenOverlayFactory = titleScreenOverlayFactory;
        this.askNewGameOverlayFactory = askNewGameOverlayFactory;
        this.powerBarFactory = powerBarFactory;
        this.ballsRemainingCounterFactory = ballsRemainingCounterFactory;
        this.debugMode = debugMode;
    }

    /**
     * Everything in this game is recycled; there is no need to re-add stuff to the physics world or
     * Heaps scene a second time.
     */
    public function update(dt:Float):Void {
        if (this.getGameData() == null) {
            // control window resizing
            this.s2d.scaleMode = LetterBox(Constants.VIEW_HEIGHT, Constants.VIEW_WIDTH, false, Center, Center);
            hxd.Window.getInstance().title = Constants.TITLE_SCREEN_TITLE;
            // hxd.Window.getInstance().
            
            // load resources
            #if release
            Res.initPak("file");
            #else
            Res.initLocal();
            #end

            // create physics world
            final physicsWorld:oimo.dynamics.World = new oimo.dynamics.World();
            
            // create and place static physics entities
            final convexHulls:Array<PhysicsEntity> = this.createStaticPhysicsEntities();
            this.addStaticPhysicsEntities(physicsWorld, convexHulls);

            // create and place ball
            final ball:Ball = this.ballFactory.createBall();
            this.addBall(physicsWorld, ball);

            // 3d setup
            final screen3dItems:Screen3dItems = this.init3dScreen();
            final mouseMove3dCoords:EventCoordinates3d = this.setupMouseMove3dEventCoordsCapture();

            // 2d ui stuff
            final screen2dItems:Screen2dItems = this.init2dScreen();

            this.setGameData(new GameData(
                physicsWorld, 
                ball,
                screen2dItems.titleScreenOverlay,
                screen2dItems.askNewGameOverlay,
                screen3dItems.cameraPosition,
                screen2dItems.powerBar,
                screen2dItems.ballsRemaining,
                screen3dItems.centerScoreboard,
                mouseMove3dCoords,
                new DoubleBufferedMutableGameState()
                ));
        } else if (this.getGameData().getMutableState().getResetRequested()) {
            final gameData:GameData = this.getGameData();
            gameData.getMutableState().setScore(0);
            gameData.getMutableState().setBallsRemaining(Constants.BRC_MAX_BALLS);
            gameData.getMutableState().setControlMode(SelectPosition);
            gameData.getAskNewGameOverlay().getTextAlphaTween().frameCount = 0;
            gameData.getMutableState().setResetRequest(false);
        }
    }

    private function init2dScreen():Screen2dItems {
        // title screen
        final titleScreenOverlay:TitleScreenOverlay = this.titleScreenOverlayFactory.createTitleScreenOverlay();
        this.s2d.addChild(titleScreenOverlay.getOverlayContainer());

        final askNewGameOverlay:AskNewGameOverlay = this.askNewGameOverlayFactory.createAskNewGameOverlay();
        this.s2d.addChild(askNewGameOverlay.getOverlayContainer());

        // balls remaining counter
        final ballsRemainingCounter:BallsRemainingCounter = this.ballsRemainingCounterFactory.createBallsRemainingCounter();
        this.s2d.addChild(ballsRemainingCounter.getContainer());

        // power bar
        final powerBar:PowerBar = this.powerBarFactory.createPowerBar();
        this.s2d.addChild(powerBar.getContainer());

        // set up black boxes for left and right borders
        final width:Float = Constants.VIEW_WIDTH * Constants.LETTERBOX_REVERSAL_RATIO;
        final xOffsetPixelsLeft:Float = Constants.BORDER_LEFT_OFFSET * Constants.LETTERBOX_REVERSAL_RATIO;
        final xOffsetPixelsRight:Float = Constants.BORDER_RIGHT_OFFSET;
        final height:Float = Constants.VIEW_HEIGHT * Constants.LETTERBOX_REVERSAL_RATIO;
        final boxLeft:Graphics = this.boxFactory2d.createBox2d(
            -width, 0, width - xOffsetPixelsLeft, height, Constants.COLOR_BLACK);
        final boxRight:Graphics = this.boxFactory2d.createBox2d(
            Constants.VIEW_WIDTH + xOffsetPixelsRight, 0, width, height, Constants.COLOR_BLACK);
        this.s2d.addChild(boxLeft);
        this.s2d.addChild(boxRight);

        

        return {
            titleScreenOverlay: titleScreenOverlay,
            askNewGameOverlay: askNewGameOverlay,
            powerBar: powerBar,
            ballsRemaining: ballsRemainingCounter
        }
    }

    private function init3dScreen():Screen3dItems {
        // set up camera
        final cameraPosition:CameraPosition = new CameraPosition();
        s3d.camera.pos.set(cameraPosition.x, cameraPosition.y, cameraPosition.z);
        s3d.camera.up = new Vector(0, 1, 0);
        
        // adds a directional light to the scene
        final directionalLight:DirLight = new DirLight(new Vector(
            Constants.DIRECTIONAL_LIGHTING_X,
            Constants.DIRECTIONAL_LIGHTING_Y,
            Constants.DIRECTIONAL_LIGHTING_Z));
        directionalLight.enableSpecular = true;
        s3d.addChild(directionalLight);

        // set the ambient light
        s3d.lightSystem.ambientLight.set(
            Constants.AMBIENT_LIGHTING_STRENGTH, 
            Constants.AMBIENT_LIGHTING_STRENGTH, 
            Constants.AMBIENT_LIGHTING_STRENGTH);

        // add 3d models
        final centerScoreboard:Scoreboard = this.addSkeeballMachinesModels();
        this.addBackWall();

        return {
            cameraPosition: cameraPosition,
            centerScoreboard: centerScoreboard
        }
    }

    private function setupMouseMove3dEventCoordsCapture():EventCoordinates3d {
        final eventPrim:Cube = new Cube(1, 1, 1, true);
        eventPrim.addNormals();
        eventPrim.addUVs();
        // still works even if the cube is invisible and behind another mesh
        final eventMesh:Mesh = new Mesh(eventPrim, Material.create(Texture.fromColor(0xbf0000)));
        eventMesh.setScale(Constants.BALL_PLACEMENT_OBJECT_SCALE);
        eventMesh.x = Constants.BALL_PLACEMENT_OBJECT_X;
        eventMesh.y = Constants.BALL_PLACEMENT_OBJECT_Y;
        eventMesh.setRotation(0, 0, Constants.BALL_PLACEMENT_OBJECT_Z_ROTATION);
        eventMesh.visible = false;
        this.s3d.addChild(eventMesh);
        final interactive:Interactive = new Interactive(eventMesh.getCollider(), this.s3d);
        final mouseMove3dCoords:EventCoordinates3d = new EventCoordinates3d(new Point(
            Constants.BALL_HOLDING_POSITION.x, 
            Constants.BALL_HOLDING_POSITION.y, 
            Constants.BALL_HOLDING_POSITION.z));
        interactive.onMove = mouseMove3dCoords.updateFromEvent;
        return mouseMove3dCoords;
    }

    private function addSkeeballMachinesModels():Scoreboard {
        var centerScoreboard:Scoreboard = null;
        for (z in Constants.MACHINES) {
            final zOffset:Float = z * (Constants.SKEEBALL_MACHINE_WIDTH + Constants.MACHINES_GAP);
            final meshes:Array<Mesh> = [
                this.boardFactory.createBoard(),
                this.hoodFactory.createHood(),
                this.laneFactory.createLane()
            ];
            for (i in 0...meshes.length) {
                final mesh:Mesh = meshes[i];
                mesh.setPosition(0, 0, zOffset);
                s3d.addChild(mesh);    
            }

            final scoreboard:Scoreboard = this.scoreboardFactory.createScoreboard();
            scoreboard.getContainer().z = zOffset;
            s3d.addChild(scoreboard.getContainer());
            if (z == 0) {
                centerScoreboard = scoreboard;
            }
        }
        return centerScoreboard;
    }

    private function addBackWall():Void {
        for (i in 0...Constants.WALL_TILES_ACROSS_SIDE) {
            for (k in 0...Constants.WALL_TILES_UP) {
                // back wall
                final plane1:Mesh = this.planeFactory.createPlane();
                plane1.x = Constants.WALL_TILE_BASE_X;
                plane1.y = Constants.WALL_TILE_BASE_Y + Constants.WALL_TILE_SIZE * k;
                plane1.z = Constants.WALL_TILE_BASE_Z - Constants.WALL_TILE_SIZE * i;
                s3d.addChild(plane1);
                final plane2:Mesh = this.planeFactory.createPlane();
                plane2.x = Constants.WALL_TILE_BASE_X;
                plane2.y = Constants.WALL_TILE_BASE_Y + Constants.WALL_TILE_SIZE * k;
                plane2.z = Constants.WALL_TILE_BASE_Z + Constants.WALL_TILE_SIZE * i;
                s3d.addChild(plane2);
            }
        }
    }

    private function createStaticPhysicsEntities():Array<PhysicsEntity> {
        return [
            this.physicsAssetDAO.getSkeeballMachine(),
            this.physicsAssetDAO.getOutOfBounds()
        ].flatten();
    }

    private function addStaticPhysicsEntities(world:oimo.dynamics.World, entities:Array<PhysicsEntity>):Void {
        for (i in 0...entities.length) {
            world.addRigidBody(entities[i].getRigidBody());
            if (this.debugMode) {
                this.s3d.addChild(entities[i].getDebugMesh());
            }
        }
    }

    private function addBall(world:oimo.dynamics.World, ball:Ball):Void {
        world.addRigidBody(ball.getPhysicsEntity().getRigidBody());
        this.s3d.addChild(ball.getContainer());
    }
}