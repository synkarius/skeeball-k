package game.data.mutable;

import h2d.col.Point;
import oimo.common.Vec3;
import resources.Constants;
import game.ui.ControlMode;

private class MutableGameState {

    public function new() {
        this.ballsRemaining = Constants.BRC_MAX_BALLS;
        this.controlMode = Title;
        this.selectedPosition = new Vec3();
        this.selectedAngle = new Point();
    }

    /* data visible to player */
    public var ballsRemaining:Int;
    public var score:Int;

    /* recorded player inputs */
    public var selectedPosition:Vec3;
    public var selectedAngle:Point;
    public var selectedPower:Float;
    
    /* internal control mechanisms */
    public var controlMode:ControlMode;
    public var resetRequested:Bool;
    public var hasBeenFired:Bool;
    public var mouseWasClicked:Bool;    
    public var ballFiringTimestamp:Float;
}

class DoubleBufferedMutableGameState {

    private final last:MutableGameState;
    private final current:MutableGameState;

    public function new() {
        this.last = new MutableGameState();
        this.current = new MutableGameState();
    }

    // setters

    public function setBallsRemaining(ballsRemaining:Int):Void {
        this.current.ballsRemaining = ballsRemaining;
    }

    public function setScore(score:Int):Void {
        this.current.score = score;
    }

    public function setControlMode(controlMode:ControlMode):Void {
        this.current.controlMode = controlMode;
    }

    public function setResetRequest(resetRequested:Bool):Void {
        this.current.resetRequested = resetRequested;
    }

    public function setSelectedPosition(x:Float, y:Float, z:Float):Void {
        this.current.selectedPosition.x = x;
        this.current.selectedPosition.y = y;
        this.current.selectedPosition.z = z;
    }

    public function setSelectedAngle(selectedAngle:Point):Void {
        this.current.selectedAngle.x = selectedAngle.x;
        this.current.selectedAngle.y = selectedAngle.y;
    }

    public function setSelectedPower(selectedPower:Float):Void {
        this.current.selectedPower = selectedPower;
    }

    public function setHasBeenFired(hasBeenFired:Bool):Void {
        this.current.hasBeenFired = hasBeenFired;
    }

    public function setMouseWasClicked(mouseWasClicked:Bool):Void {
        this.current.mouseWasClicked = mouseWasClicked;
    }

    public function setBallFiringTimestamp(timestamp:Float):Void {
        this.current.ballFiringTimestamp = timestamp;
    }

    // getters: current frame

    public function getBallsRemaining():Int {
        return this.current.ballsRemaining;
    }

    public function getScore():Int {
        return this.current.score;
    }

    public function getControlMode():ControlMode {
        return this.current.controlMode;
    }

    public function getResetRequested():Bool {
        return this.current.resetRequested;
    }

    public function getSelectedPosition():Vec3 {
        return this.current.selectedPosition;
    }

    public function getSelectedAngle():Point {
        return this.current.selectedAngle;
    }

    public function getSelectedPower():Float {
        return this.current.selectedPower;
    }

    public function getHasBeenFired():Bool {
        return this.current.hasBeenFired;
    }

    public function getMouseWasClicked():Bool {
        return this.current.mouseWasClicked;
    }

    public function getBallFiringTimestamp() {
        return this.current.ballFiringTimestamp;
    }

    // getters: last frame

    public function getLastFrameBallsRemaining():Int {
        return this.last.ballsRemaining;
    }

    public function getLastFrameScore():Int {
        return this.last.score;
    }

    public function getLastFrameControlMode():ControlMode {
        return this.last.controlMode;
    }

    // sync current and last frame

    public function copyCurrentToLast():Void { 
        this.last.ballsRemaining = this.current.ballsRemaining;
        this.last.score = this.current.score;
        this.last.controlMode = this.current.controlMode;
    }
}