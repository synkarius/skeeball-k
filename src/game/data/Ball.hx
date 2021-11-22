package game.data;

import h3d.scene.Object;
import physics.entities.PhysicsEntity;

@:build(macros.RecordClassMacro.Record.build())
class Ball {

    var physicsEntity:PhysicsEntity;
    var container:Object;
    var arrowContainer:Object;
}