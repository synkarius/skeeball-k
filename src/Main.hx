package;

import factories.ui.AskNewGameOverlayFactory;
import systems.UiAnimationSystem;
import systems.ArrowSystem;
import systems.ScoreboardSystem;
import systems.StateSyncSystem;
import systems.CameraSystem;
import systems.InputSystem;
import factories.meshes.ArrowModelFactory;
import systems.UiVisibilitySystem;
import factories.ui.BallsRemainingCounterFactory;
import factories.ui.PowerBarFactory;
import factories.ui.TitleScreenOverlayFactory;
import factories.ui.BoxFactory2d;
import factories.BallFactory;
import factories.SpherePhysicsEntityFactory;
import factories.meshes.PlaneFactory;
import factories.DigitMaterialsFactory;
import factories.ScoreboardFactory;
import resources.parsers.PhysicsParser;
import resources.PhysicsAssetDAO;
import factories.meshes.BoardModelFactory;
import factories.meshes.LaneModelFactory;
import resources.parsers.MeshParser;
import factories.meshes.HoodModelFactory;
import systems.System;
import resources.parsers.MeshOBJParser;
import resources.parsers.PhysicsOBJParser;
import game.data.GameData;
import systems.BallSystem;
import systems.debug.InputDebugSystem;
import systems.PhysicsSystem;
import systems.SetupSystem;

class Main extends hxd.App {

    private var gameData:GameData;
    private var systems:Array<System>;
    private var time:Float;
    
    override function init() {
        // close console window that launches with heaps
        hl.UI.closeConsole(); 

        // dependency injection
        final meshParser:MeshParser = new MeshOBJParser();
        final boardFactory:BoardModelFactory = new SimpleBoardModelFactory(meshParser);
        final hoodFactory:HoodModelFactory = new SimpleHoodModelFactory(meshParser);
        final laneFactory:LaneModelFactory = new SimpleModelLaneFactory(meshParser);
        final digitMaterialsFactory:DigitMaterialsFactory = new CachedDigitMaterialsFactory();
        final scoreboardFactory:ScoreboardFactory = new SimpleScoreboardFactory(meshParser, digitMaterialsFactory);
        final planeFactory:PlaneFactory = new SimplePlaneFactory(meshParser);
        final physicsParser:PhysicsParser = new PhysicsOBJParser();
        final physicsAssetDAO:PhysicsAssetDAO = new StaticDataPhysicsAssetDAO(physicsParser);
        final spherePhysicsEntityFactory:SpherePhysicsEntityFactory = new SpherePhysicsEntityFactory();
        final arrowModelFactory:ArrowModelFactory = new SimpleArrowModelFactory(meshParser);
        final ballFactory:BallFactory = new BallFactory(spherePhysicsEntityFactory, arrowModelFactory);
        final boxFactory2d:BoxFactory2d = new BoxFactory2d();
        final titleScreenOverlayFactory:TitleScreenOverlayFactory = new SimpleTitleScreenOverlayFactory(boxFactory2d);
        final askNewGameOverlayFactory:AskNewGameOverlayFactory = new SimpleAskNewGameOverlayFactory(boxFactory2d);
        final powerBarFactory:PowerBarFactory = new SimplePowerBarFactory(boxFactory2d);
        final ballsRemainingCounterFactory:BallsRemainingCounterFactory = new SimpleBallsRemainingCounterFactory();
        final setupSystem:System = new SetupSystem(
            this.getGameData,
            this.setGameData, 
            s2d, 
            s3d, 
            physicsAssetDAO, 
            boardFactory, 
            hoodFactory, 
            laneFactory, 
            scoreboardFactory, 
            planeFactory,
            ballFactory,
            boxFactory2d,
            titleScreenOverlayFactory,
            askNewGameOverlayFactory,
            powerBarFactory,
            ballsRemainingCounterFactory,
            false);

        // ECS-like systems
        this.systems = [
            setupSystem,
            #if !release
            new InputDebugSystem(this.s3d, this.getGameData),
            #end
            new InputSystem(this.getGameData),
            new PhysicsSystem(this.getGameData),
            new BallSystem(this.getGameData, this.s3d),
            new ArrowSystem(this.getGameData),
            new UiAnimationSystem(this.getGameData),
            new UiVisibilitySystem(this.getGameData),
            new ScoreboardSystem(this.getGameData, digitMaterialsFactory),
            new CameraSystem(this.getGameData, this.s3d.camera),
            new StateSyncSystem(this.getGameData)
        ];
    }

    override function update( dt : Float ) {
        for (i in 0...this.systems.length) {
            this.systems[i].update( dt );
        }
	}

    static function main() {
        new Main();
    }

    private function setGameData(gameData:GameData):Void {
        this.gameData = gameData;
    }

    private function getGameData():GameData {
        return this.gameData;
    }    
}