package factories.ui;

import game.data.mutable.tweens.PowerBarHeight;
import resources.Constants;
import h2d.Object;
import game.ui.PowerBar;

interface PowerBarFactory {
    public function createPowerBar():PowerBar;
}

class SimplePowerBarFactory implements PowerBarFactory {

    private final boxFactory2d:BoxFactory2d;

    public function new(boxFactory2d:BoxFactory2d) {
        this.boxFactory2d = boxFactory2d;
    }

    public function createPowerBar():PowerBar {
        final level:Object = this.boxFactory2d.createBox2d(
            0, 
            0, 
            Constants.POWER_BAR_LEVEL_WIDTH, 
            Constants.POWER_BAR_LEVEL_HEIGHT, 
            Constants.COLOR_ORANGE);
        
        final container:Object = new Object();
        container.addChild(level);
        container.visible = false;
        final xOffsetPixelsLeft:Float = Constants.BORDER_LEFT_OFFSET * Constants.LETTERBOX_REVERSAL_RATIO;
        container.x = -xOffsetPixelsLeft + Constants.POWER_BAR_CONTAINER_X;
        container.y = Constants.POWER_BAR_CONTAINER_Y;

        return new PowerBar(container, level, new PowerBarHeight());
    }
}