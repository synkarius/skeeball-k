package game.data;

import h3d.scene.Object;
import h3d.scene.Mesh;

@:build(macros.RecordClassMacro.Record.build())
class Scoreboard {

    var container:Object;
    var hundreds:Mesh;
    var tens:Mesh;
    var ones:Mesh;
}