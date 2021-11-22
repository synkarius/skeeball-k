package resources.parsers;

import physics.entities.PhysicsEntity;
import hxd.res.Resource;

interface PhysicsParser {
    public function parse(resource:Resource):PhysicsEntity;
}