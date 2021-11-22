package exceptions;

import haxe.Exception;

class BallCatchSensitivityException extends Exception {

    public function new(catches:Array<Int>) {
        super("ball catches which were too close: " + catches.map(Std.string).join(", "));
    }
}