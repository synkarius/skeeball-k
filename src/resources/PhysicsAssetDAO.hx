package resources;

import resources.parsers.PhysicsParser;
import oimo.common.Vec3;
import physics.entities.PhysicsEntity;
import hxd.Res;
import hxd.res.Resource;
using Lambda;

interface PhysicsAssetDAO {

    /**
     * Returns all skeeball machine physics entities.
     * @return Array<PhysicsEntity>
     */
    public function getSkeeballMachine():Array<PhysicsEntity>;

    /**
     * Returns out of bounds physics entities for the left and right sides of the skeeball machine.
     * @return PhysicsEntity
     */
    public function getOutOfBounds():Array<PhysicsEntity>;
}

class StaticDataPhysicsAssetDAO implements PhysicsAssetDAO {

    private static final SKEEBALL_MACHINE_WIDTH:Float = Constants.SKEEBALL_MACHINE_WIDTH + Constants.MACHINES_GAP;
    private static final RAIL_WIDTH:Float = Constants.RAIL_WIDTH + Constants.MACHINES_GAP;

    private final physicsParser:PhysicsParser;

    public function new(physicsParser:PhysicsParser) {
        this.physicsParser = physicsParser;
    }

    public function getSkeeballMachine():Array<PhysicsEntity> {
        return [
            this.getBallCatch1(),
            this.getBallCatch2(),
            this.getBallCatch3(),
            this.getBallCatch4And5(),
            this.getBoard(),
            this.getInnerRim(),
            this.getOuterRim(),
            this.getLane()
        ].flatten()
        .map(this.physicsParser.parse);
    }

    public function getOutOfBounds():Array<PhysicsEntity> {
        return [
            this.getOutOfBoundsBackboards(),
            this.getOutOfBoundsRailLeftSide(),
            this.getOutOfBoundsRailRightSide()
        ].flatten();
    }

    private function getOutOfBoundsBackboards():Array<PhysicsEntity> {
        final backboardLeft:PhysicsEntity = this.physicsParser.parse(Res.physics.lane_07);
        this.zOffsetPhysicsEntity(backboardLeft, -SKEEBALL_MACHINE_WIDTH);
        final backboardRight:PhysicsEntity = this.physicsParser.parse(Res.physics.lane_07);
        this.zOffsetPhysicsEntity(backboardRight, SKEEBALL_MACHINE_WIDTH);
        return [backboardLeft, backboardRight];
    }

    private function getOutOfBoundsRailLeftSide():Array<PhysicsEntity> {
        return [
            Res.physics.lane_05,
            Res.physics.lane_09,
            Res.physics.lane_10,
            Res.physics.lane_11
            ].map(this.physicsParser.parse)
            .map(e -> this.zOffsetPhysicsEntity(e, -RAIL_WIDTH));
    }

    private function getOutOfBoundsRailRightSide():Array<PhysicsEntity> {
        return [
            Res.physics.lane_06,
            Res.physics.lane_12,
            Res.physics.lane_13,
            Res.physics.lane_14
            ].map(this.physicsParser.parse)
            .map(e -> this.zOffsetPhysicsEntity(e, RAIL_WIDTH));
    }

    private function zOffsetPhysicsEntity(e:PhysicsEntity, z:Float):PhysicsEntity {
        e.getRigidBody().setPosition(new Vec3(0, 0, z));
        e.getDebugMesh().setPosition(0, 0, z);
        return e;
    }

    private function getBallCatch1():Array<Resource> {
        return [
            Res.physics.ball_catch_1,
            Res.physics.ball_catch_1_rim_1,
            Res.physics.ball_catch_1_rim_2,
            Res.physics.ball_catch_1_rim_3,
            Res.physics.ball_catch_1_rim_4,
            Res.physics.ball_catch_1_rim_5,
            Res.physics.ball_catch_1_rim_6,
            Res.physics.ball_catch_1_rim_7,
            Res.physics.ball_catch_1_rim_8
        ];
    }

    private function getBallCatch2():Array<Resource> {
        return [
            Res.physics.ball_catch_2,
            Res.physics.ball_catch_2_rim_1,
            Res.physics.ball_catch_2_rim_2,
            Res.physics.ball_catch_2_rim_3,
            Res.physics.ball_catch_2_rim_4,
            Res.physics.ball_catch_2_rim_5,
            Res.physics.ball_catch_2_rim_6,
            Res.physics.ball_catch_2_rim_7,
            Res.physics.ball_catch_2_rim_8
        ];
    }

    private function getBallCatch3():Array<Resource> {
        return [
            Res.physics.ball_catch_3,
            Res.physics.ball_catch_3_rim_1,
            Res.physics.ball_catch_3_rim_2,
            Res.physics.ball_catch_3_rim_3,
            Res.physics.ball_catch_3_rim_4,
            Res.physics.ball_catch_3_rim_5,
            Res.physics.ball_catch_3_rim_6,
            Res.physics.ball_catch_3_rim_7,
            Res.physics.ball_catch_3_rim_8
        ];
    }

    private function getBallCatch4And5():Array<Resource> {
        return [
            Res.physics.ball_catch_4,
            Res.physics.ball_catch_5
        ];
    }

    private function getBoard():Array<Resource> {
        return [
            Res.physics.board_01a,
            Res.physics.board_01b,
            Res.physics.board_02a,
            Res.physics.board_02b,
            Res.physics.board_03a,
            Res.physics.board_03b,
            Res.physics.board_04a,
            Res.physics.board_04b,
            Res.physics.board_05a,
            Res.physics.board_05b,
            Res.physics.board_06a,
            Res.physics.board_06b,
            Res.physics.board_07a,
            Res.physics.board_07b,
            Res.physics.board_08a,
            Res.physics.board_08b,
            Res.physics.board_09a,
            Res.physics.board_09b,
            Res.physics.board_10a,
            Res.physics.board_10b,
            Res.physics.board_11a,
            Res.physics.board_11b,
            Res.physics.board_12a,
            Res.physics.board_12b,
            Res.physics.board_13a,
            Res.physics.board_13b,
            Res.physics.board_14a,
            Res.physics.board_14b,
            Res.physics.board_15a,
            Res.physics.board_15b,
            Res.physics.board_16a,
            Res.physics.board_16b,
            Res.physics.board_17a,
            Res.physics.board_17b,
            Res.physics.board_18a,
            Res.physics.board_18b,
            Res.physics.board_19a,
            Res.physics.board_19b,
            Res.physics.board_20a,
            Res.physics.board_20b,
            Res.physics.board_21a,
            Res.physics.board_21b
        ];
    }

    private function getInnerRim():Array<Resource> {
        return [
            Res.physics.rim_inner_1a,
            Res.physics.rim_inner_1b,
            Res.physics.rim_inner_2a,
            Res.physics.rim_inner_2b,
            Res.physics.rim_inner_3a,
            Res.physics.rim_inner_3b,
            Res.physics.rim_inner_4a,
            Res.physics.rim_inner_4b
        ];
    }

    private function getOuterRim():Array<Resource> {
        return [
            Res.physics.rim_outer_1a,
            Res.physics.rim_outer_1b,
            Res.physics.rim_outer_2a,
            Res.physics.rim_outer_2b,
            Res.physics.rim_outer_3a,
            Res.physics.rim_outer_3b,
            Res.physics.rim_outer_4a,
            Res.physics.rim_outer_4b
        ];
    }

    private function getLane():Array<Resource> {
        return [
            Res.physics.lane_01,
            Res.physics.lane_02,
            Res.physics.lane_03,
            Res.physics.lane_04,
            Res.physics.lane_05,
            Res.physics.lane_06,
            Res.physics.lane_07,
            Res.physics.lane_08,
            Res.physics.lane_09,
            Res.physics.lane_10,
            Res.physics.lane_11,
            Res.physics.lane_12,
            Res.physics.lane_13,
            Res.physics.lane_14
        ];
    }
}