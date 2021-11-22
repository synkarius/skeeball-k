package factories.ui;

import game.data.mutable.tweens.TweenedAlpha;
import game.ui.AskNewGameOverlay;
import h2d.Text;
import hxd.Res;
import h2d.Font;
import resources.Constants;
import h2d.Graphics;
import h2d.Object;

interface AskNewGameOverlayFactory {
    public function createAskNewGameOverlay():AskNewGameOverlay;
}

class SimpleAskNewGameOverlayFactory extends BaseOverlayFactory implements AskNewGameOverlayFactory {

    private final boxFactory2d:BoxFactory2d;

    public function new(boxFactory2d:BoxFactory2d) {
        this.boxFactory2d = boxFactory2d;
    }

    public function createAskNewGameOverlay():AskNewGameOverlay {
        final xOffsetPixelsLeft:Float = Constants.BORDER_LEFT_OFFSET * Constants.LETTERBOX_REVERSAL_RATIO;
        final overlayContainer:Object = new Object();
        final midBox:Graphics = this.boxFactory2d.createBox2d(
            -xOffsetPixelsLeft, 
            Constants.MIDBOX_Y_OFFSET, 
            Constants.VIEW_WIDTH + xOffsetPixelsLeft + Constants.BORDER_RIGHT_OFFSET, 
            Constants.VIEW_HEIGHT, 
            Constants.COLOR_WHITE);
        midBox.alpha = Constants.MIDBOX_ALPHA;
        overlayContainer.addChild(midBox);
        overlayContainer.visible = false;
        
        final font:Font = Res.fonts.hand_drawn_shapes_fnt.toFont();
        
        // "ask" prompt
        final askPrompt:Text = this.createBasicText(font.clone());
        askPrompt.text = Constants.NEW_GAME_PROMPT_TEXT;
        askPrompt.font.resizeTo(Constants.BEGIN_PROMPT_FONT_SIZE);
        askPrompt.x = Constants.NEW_GAME_PROMPT_X;
        askPrompt.y = Constants.NEW_GAME_PROMPT_Y;
        overlayContainer.addChild(askPrompt);
        
        // tween tracker
        final tracker:TweenedAlpha = new TweenedAlpha(0., 0);

        return new AskNewGameOverlay(overlayContainer, tracker);
    }
}