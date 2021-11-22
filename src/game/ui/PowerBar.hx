package game.ui;

import game.data.mutable.tweens.PowerBarHeight;
import h2d.Object;

@:build(macros.RecordClassMacro.Record.build())
class PowerBar {

    var container:Object;
    var level:Object;
    var height:PowerBarHeight;
}