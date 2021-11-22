package factories.ui;

import resources.Constants;
import hxd.Res;
import h2d.Bitmap;
import h2d.Object;
import game.ui.BallsRemainingCounter;

interface BallsRemainingCounterFactory {
    public function createBallsRemainingCounter():BallsRemainingCounter;
}

class SimpleBallsRemainingCounterFactory implements BallsRemainingCounterFactory {

    public function new() {}

    public function createBallsRemainingCounter():BallsRemainingCounter {
        final container:Object = new Object();
        container.x = Constants.VIEW_WIDTH - Constants.BRC_CONTAINER_X_OFFSET;
        container.y = Constants.BRC_CONTAINER_Y_OFFSET;
        container.visible = false;

        final balls:Array<Object> = [];

        for (i in 0...Constants.BRC_MAX_BALLS) {
            final ballIcon:Object = this.createBallIcon(i);
            container.addChild(ballIcon);
            balls.push(ballIcon);
        }

        return new BallsRemainingCounter(container, balls);
    }

    private function createBallIcon(n:Int):Object {
        final bitmap = new Bitmap(Res.ui.ballIcon.toTile());
        bitmap.y = Constants.VIEW_HEIGHT - (Constants.BRC_ICON_Y_OFFSET * (n + 1));
        return bitmap;
    }
}