package resources;

import oimo.common.Vec3;

class Constants {
    // screen size
    public static final VIEW_WIDTH:Int = 800;
    public static final VIEW_HEIGHT:Int = 600;
    public static final VIEW_RATIO:Float = VIEW_WIDTH * 1. / VIEW_HEIGHT;

    // 3d models
    public static final SKEEBALL_MACHINE_WIDTH:Float = 4.895618;
    public static final RAIL_WIDTH:Float = 0.608289;
    public static final MACHINES_GAP:Float = 0.1;
    public static final MACHINES:Array<Int> = [-3, -2, -1, 0, 1, 2, 3];
    public static final COLOR_GRAY:Int = 0x727272;

    // ball
    public static final BALL_X:Float = -2.35;
    public static final BALL_Y:Float = 3.;
    public static final BALL_Z:Float = 0.4;
    public static final BALL_RADIUS:Float = .205;
    public static final BALL_HOLDING_POSITION:Vec3 = new Vec3(12., -1.7215, 0);
    public static final BALL_HOLDING_LINEAR_VELOCITY:Vec3 = new Vec3(0, 0, 0);

    // ball catches 0-5 (0 is the pit, 5 is the top)
    public static final BALL_CATCH_0_X:Float = 0.8966366;
    public static final BALL_CATCH_0_Y:Float = -1.6195622;
    public static final BALL_CATCH_1_X:Float = -0.5658685;
    public static final BALL_CATCH_1_Y:Float = -1.0956724;
    public static final BALL_CATCH_2_X:Float = -1.1866491;
    public static final BALL_CATCH_2_Y:Float = -0.5965524;
    public static final BALL_CATCH_3_X:Float = -1.6692407;
    public static final BALL_CATCH_3_Y:Float = 0.0209411;
    public static final BALL_CATCH_4_X:Float = -2.1862897;
    public static final BALL_CATCH_4_Y:Float = 0.6652515;
    public static final BALL_CATCH_5_X:Float = -2.7148669;
    public static final BALL_CATCH_5_Y:Float = 1.4166119;
    // out of bounds
    public static final OUT_OF_BOUNDS_X_MIN:Float = -4.2399;
    public static final OUT_OF_BOUNDS_X_MAX:Float = 15.27;
    public static final OUT_OF_BOUNDS_Y_MIN:Float = -2.7299;
    public static final OUT_OF_BOUNDS_Y_MAX:Float = 6.7099;
    public static final OUT_OF_BOUNDS_Z_MIN:Float = -3.159;
    public static final OUT_OF_BOUNDS_Z_MAX:Float = 3.159;
    public static final OUT_OF_BOUNDS_TIMEOUT_SECONDS:Float = 15.;
    
    // scoreboard
    public static final SCOREBOARD_DIGIT_X:Float = -3.8269899;
    public static final SCOREBOARD_DIGIT_Y:Float = 2.4969;
    /**
     * z position is calculated (after scaling) as: 
     *      0 - ( mesh.getBounds().getSize().z / 2 )
     */
    //public static final SCOREBOARD_DIGIT_Z:Float = -0.6445; 
    public static final SCOREBOARD_DIGIT_SCALE:Float = 0.6945;

    // wall / floor
    public static final WALL_TILE_SIZE:Float = 2.;
    public static final WALL_TILE_BASE_X:Float = -5.436989;
    public static final WALL_TILE_BASE_Y:Float = 2.6369;
    public static final WALL_TILE_BASE_Z:Float = -0.5;
    public static final WALL_TILES_ACROSS_SIDE:Int = 10;
    public static final WALL_TILES_UP:Int = 4;
    public static final FLOOR_SCALE:Float = 12.;
    public static final FLOOR_TILE_BASE_X:Float = 12.5;
    public static final FLOOR_TILE_BASE_Y:Float = -26.7;
    public static final FLOOR_TILE_BASE_Z:Float = -11.5;

    // camera
    public static final CAM_MENU_POSITION_X:Float = 10;
    public static final CAM_MENU_POSITION_Y:Float = 10;
    public static final CAM_MENU_POSITION_Z:Float = -10;
    public static final CAM_PLAY_POSITION_X:Float = 38;
    public static final CAM_PLAY_POSITION_Y:Float = 7.5;
    public static final CAM_PLAY_POSITION_Z:Float = 0;
    public static final CAMERA_TRANSITION_TOTAL_FRAMES:Int = 60;

    // lights
    public static final AMBIENT_LIGHTING_STRENGTH:Float = .25;
    public static final DIRECTIONAL_LIGHTING_X:Float = -12.6 * 1.2;
    public static final DIRECTIONAL_LIGHTING_Y:Float = -19.5 * 1.2;
    public static final DIRECTIONAL_LIGHTING_Z:Float = 5.2 * 1.2;

    // ui
    public static final LETTERBOX_REVERSAL_RATIO:Float = 1/.75;
    public static final BORDER_LEFT_OFFSET:Float = 175.;
    public static final BORDER_RIGHT_OFFSET:Float = 35.;
    public static final COLOR_BLACK:Int = 0x000000;
    public static final COLOR_WHITE:Int = 0xffffff;
    public static final COLOR_ORANGE:Int = 0xc1801b;
    // title screen
    public static final MIDBOX_Y_OFFSET:Float = 100.;
    public static final MIDBOX_ALPHA:Float = 0.5;
    public static final TITLE_SCREEN_TITLE:String = "Skeeball K";
    public static final TITLE_X:Float = -115.;
    public static final TITLE_Y:Float = 240.;
    public static final TITLE_ALPHA:Float = 0.8;
    public static final TITLE_FONT_SIZE:Int = 256;
    public static final BEGIN_PROMPT_TEXT:String = "Press ENTER to Start";
    public static final BEGIN_PROMPT_X:Float = 60.;
    public static final BEGIN_PROMPT_Y:Float = 515.;
    public static final BEGIN_PROMPT_FONT_SIZE:Int = 72;
    public static final BEGIN_PROMPT_TOTAL_FRAMES:Int = 120;
    // new game ask screen
    public static final NEW_GAME_PROMPT_TEXT:String = "Press ENTER to Play Again";
    public static final NEW_GAME_PROMPT_X:Float = 0.;
    public static final NEW_GAME_PROMPT_Y:Float = 425.;
    public static final NEW_GAME_PROMPT_TOTAL_FRAMES:Int = 150;
    // balls remaining counter
    public static final BRC_ICON_Y_OFFSET:Float = 50;
    public static final BRC_MAX_BALLS:Int = 10;
    public static final BRC_CONTAINER_X_OFFSET:Float = 20;
    public static final BRC_CONTAINER_Y_OFFSET:Float = 20;
    // power bar
    public static final POWER_BAR_CONTAINER_X:Float = 20;
    public static final POWER_BAR_CONTAINER_Y:Float = VIEW_HEIGHT;
    public static final POWER_BAR_LEVEL_WIDTH:Float = 80;
    public static final POWER_BAR_LEVEL_HEIGHT:Float = 360;
    public static final POWER_BAR_TOTAL_FRAMES:Int = 180;
    // ball arrow
    public static final ARROW_MODEL_SCALE:Float = 0.5;
    public static final ARROW_MODEL_X:Float = -1.;
    public static final ARROW_MODEL_Y:Float = 0.2;
    // ball placement
    public static final BALL_PLACEMENT_OBJECT_SCALE:Float = 10.88;
    public static final BALL_PLACEMENT_OBJECT_X:Float = 8.277;
    public static final BALL_PLACEMENT_OBJECT_Y:Float = -7.387;
    public static final BALL_PLACEMENT_OBJECT_Z_ROTATION:Float = -0.006;
    public static final BALL_PLACEMENT_OBJECT_XMIN:Float = 11.0883504;
    public static final BALL_PLACEMENT_OBJECT_XMAX:Float = 13.714964;
    public static final BALL_PLACEMENT_OBJECT_YMIN:Float = -1.7745263;
    public static final BALL_PLACEMENT_OBJECT_ZMIN:Float = -1.5665994;
    public static final BALL_PLACEMENT_OBJECT_ZMAX:Float = 1.5665994;
    // controls
    public static final POWER_MULTIPLIER:Float = 20.;
}