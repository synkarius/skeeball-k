package systems;

import h2d.col.Point;
import game.data.mutable.EventCoordinates3d;
import h3d.scene.Scene;
import h3d.scene.Object;
import resources.Constants;
import oimo.dynamics.rigidbody.RigidBody;
import game.data.GameData;
import game.data.Ball;
import oimo.common.Vec3;
import physics.entities.PhysicsEntity;
import exceptions.BallCatchSensitivityException;

private typedef BallCatch = {
    final x:Float;
    final y:Float;
    final value:Int;
}

/**
 * Responsible for:
 * - keeping the ball mesh in sync w/ the ball physics entity
 * - resetting the ball physics entity after a score or out-of-bounds or timeout
 * - positioning the ball during the controls positioning phase
 * - firing the ball once all inputs are collected
 */
class BallSystem implements System {

    private static final LANE_MODEL_NAME:String = "model-lane.obj";
    private static final BALL_CATCHES:Array<BallCatch> = [
        { x: Constants.BALL_CATCH_1_X, y: Constants.BALL_CATCH_1_Y, value: 10 },
        { x: Constants.BALL_CATCH_2_X, y: Constants.BALL_CATCH_2_Y, value: 20 },
        { x: Constants.BALL_CATCH_3_X, y: Constants.BALL_CATCH_3_Y, value: 30 },
        { x: Constants.BALL_CATCH_4_X, y: Constants.BALL_CATCH_4_Y, value: 40 },
        { x: Constants.BALL_CATCH_5_X, y: Constants.BALL_CATCH_5_Y, value: 50 },
    ];

    private final getGameData: Void -> GameData;
    private final s3d:Scene;
    // tempVector is so that I don't have to allocate a new vector every frame just to pass coords
    private final tempVector:Vec3;

    public function new(getGameData: Void -> GameData, s3d:Scene){
        this.getGameData = getGameData;
        this.s3d = s3d;
        this.tempVector = new Vec3();
    }

    public function update(dt:Float):Void {
        final gameData:GameData = this.getGameData();

        switch (gameData.getMutableState().getControlMode()) {
            case Title: this.holdBallAtReadyPosition();
            case SelectPosition: this.moveBallToSelectedPosition();
            case SelectAngle, SelectPower: this.holdBallAtSelectedPosition();
            case BallIsMoving:this.fireAndRollBall();
            case AskNewGame: false; // pass
        }

        final ball:Ball = gameData.getBall();
        this.updateBallMeshPosition(ball.getPhysicsEntity(), ball.getContainer());
    }

    private function fireAndRollBall():Void {
        final gameData:GameData = this.getGameData();

        // fire ball if hasn't been fired yet
        if (!gameData.getMutableState().getHasBeenFired()) {
            // position
            final ballRigidBody:RigidBody = gameData.getBall().getPhysicsEntity().getRigidBody();
            this.tempVector.x = gameData.getMutableState().getSelectedPosition().x;
            this.tempVector.y = gameData.getMutableState().getSelectedPosition().y;
            this.tempVector.z = gameData.getMutableState().getSelectedPosition().z;
            ballRigidBody.setPosition(this.tempVector);
            // power
            final power:Float = gameData.getMutableState().getSelectedPower() * Constants.POWER_MULTIPLIER;
            // direction
            /*
            * There are a couple of things going on here.
            * 1. `y` in 2d space is `x` in 3d space.
            * 2. `x` in 2d space is `z` in 3d space.
            * 3. Both of those need to be flipped around in 3d space.
            * 4. `angle` is a set of screen coords relativized to the center/bottom of the screen.
            *    We don't want it to be the case that the further towards the top of the screen
            *    you clicked, the more power the ball has, so we're using `divisor` here to
            *    normalize those coords.
            * 5. Then we apply the selected power.
            */
            final angle:Point = gameData.getMutableState().getSelectedAngle();
            final divisor:Float = Math.max(Math.abs(angle.x), Math.abs(angle.y));
            final invertDirection:Float = -1;
            this.tempVector.x = angle.y / divisor * invertDirection * power;
            this.tempVector.y = 0;
            this.tempVector.z = angle.x / divisor * invertDirection * power;
            // and fire
            ballRigidBody.setLinearVelocity(this.tempVector);


            gameData.getMutableState().setHasBeenFired(true);
            gameData.getMutableState().setBallFiringTimestamp(haxe.Timer.stamp());
        } else {
            final ballPosition:Vec3 = gameData.getBall().getPhysicsEntity().getRigidBody().getPosition();
            final detectedBallCatch:Array<BallCatch> = BALL_CATCHES
                .filter(ballCatch -> this.ballIsAtBallCatch(ballPosition, ballCatch));
            // there should be 0 or 1, or the sensitivity is too large
            if (detectedBallCatch.length > 1) {
                throw new BallCatchSensitivityException(detectedBallCatch.map(bc -> bc.value));
            } else if (detectedBallCatch.length == 1) {
                final ballCatch:BallCatch = detectedBallCatch[0];
                gameData.addToScore(ballCatch.value);
                this.nextBall();
            } else if (this.ballIsInThePit(ballPosition) || this.ballIsOutOfBounds(ballPosition) || this.ballTimedOut()) {
                this.nextBall();
            }

            if (gameData.getMutableState().getBallsRemaining() == 0) {
                gameData.getMutableState().setControlMode(AskNewGame);        
            }
        }
    }

    private function nextBall():Void {
        final gameData:GameData = this.getGameData();
        gameData.decrementBallsRemaining();
        gameData.getMutableState().setHasBeenFired(false);
        gameData.getMutableState().setControlMode(SelectPosition);
    }

    private function ballTimedOut():Bool {
        final start:Float = this.getGameData().getMutableState().getBallFiringTimestamp();
        final now:Float = haxe.Timer.stamp();
        return now - start > Constants.OUT_OF_BOUNDS_TIMEOUT_SECONDS;
    }

    private function ballIsAtBallCatch(ballPosition:Vec3, ballCatch:BallCatch):Bool {
        return Math.abs(ballPosition.x - ballCatch.x) < Constants.BALL_RADIUS
            && Math.abs(ballPosition.y - ballCatch.y) < Constants.BALL_RADIUS
            && Math.abs(ballPosition.z - 0) < Constants.BALL_RADIUS;
    }

    private function ballIsInThePit(ballPosition:Vec3):Bool {
        return Math.abs(ballPosition.x - Constants.BALL_CATCH_0_X) < Constants.BALL_RADIUS
            && Math.abs(ballPosition.y - Constants.BALL_CATCH_0_Y) < Constants.BALL_RADIUS;
    }

    private function ballIsOutOfBounds(ballPosition:Vec3):Bool {
        return ballPosition.x > Constants.OUT_OF_BOUNDS_X_MAX || ballPosition.x < Constants.OUT_OF_BOUNDS_X_MIN
            || ballPosition.y > Constants.OUT_OF_BOUNDS_Y_MAX || ballPosition.y < Constants.OUT_OF_BOUNDS_Y_MIN
            || ballPosition.z > Constants.OUT_OF_BOUNDS_Z_MAX || ballPosition.z < Constants.OUT_OF_BOUNDS_Z_MIN;
    }

    private function moveBallToSelectedPosition():Void {
        final gameData:GameData = this.getGameData();
        final position:Vec3 = this.calculatePositionDuringBallPlacement(gameData.getMouseMove3dCoordinates());
        gameData.getMutableState().setSelectedPosition(position.x, position.y, position.z);

        final rigidBody:RigidBody = gameData.getBall().getPhysicsEntity().getRigidBody();
        rigidBody.setPosition(gameData.getMutableState().getSelectedPosition());
        rigidBody.setLinearVelocity(Constants.BALL_HOLDING_LINEAR_VELOCITY);
    }

    private function calculatePositionDuringBallPlacement(mouseMove3dCoordinates:EventCoordinates3d):Vec3 {
        final result:Vec3 = this.tempVector; // recycle this Vec3 to reduce GC
        result.x = mouseMove3dCoordinates.getX();
        result.y = mouseMove3dCoordinates.getY() + Constants.BALL_RADIUS;
        result.z = mouseMove3dCoordinates.getZ();

        if (result.x < Constants.BALL_PLACEMENT_OBJECT_XMIN) {
            result.x = Constants.BALL_PLACEMENT_OBJECT_XMIN;
        } else if (result.x > Constants.BALL_PLACEMENT_OBJECT_XMAX) {
            result.x = Constants.BALL_PLACEMENT_OBJECT_XMAX;
        }

        if (result.y < Constants.BALL_PLACEMENT_OBJECT_YMIN) {
            result.y = Constants.BALL_PLACEMENT_OBJECT_YMIN;
        }

        if (result.z < Constants.BALL_PLACEMENT_OBJECT_ZMIN) {
            result.z = Constants.BALL_PLACEMENT_OBJECT_ZMIN;
        } else if (result.z > Constants.BALL_PLACEMENT_OBJECT_ZMAX) {
            result.z = Constants.BALL_PLACEMENT_OBJECT_ZMAX;
        }

        return result;
    }

    private function holdBallAtReadyPosition():Void {
        final gameData:GameData = this.getGameData();
        final rigidBody:RigidBody = gameData.getBall().getPhysicsEntity().getRigidBody();
        rigidBody.setPosition(Constants.BALL_HOLDING_POSITION);
        rigidBody.setLinearVelocity(Constants.BALL_HOLDING_LINEAR_VELOCITY);
    }

    private function holdBallAtSelectedPosition():Void {
        final gameData:GameData = this.getGameData();
        final rigidBody:RigidBody = gameData.getBall().getPhysicsEntity().getRigidBody();
        rigidBody.setPosition(gameData.getMutableState().getSelectedPosition());
        rigidBody.setLinearVelocity(Constants.BALL_HOLDING_LINEAR_VELOCITY);
    }

    /**
     * Update the center position of the sphere mesh, based on the center position of the rigid body.
     * @param entity 
     */
     private function updateBallMeshPosition(entity:PhysicsEntity, container:Object):Void {
        final ballPosition:Vec3 = entity.getRigidBody().getPosition();
        container.setPosition(ballPosition.x, ballPosition.y, ballPosition.z);
    }
}