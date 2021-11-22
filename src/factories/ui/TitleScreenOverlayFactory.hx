package factories.ui;

import game.data.mutable.tweens.TweenedAlpha;
import h2d.Text;
import hxd.Res;
import h2d.Font;
import resources.Constants;
import h2d.Graphics;
import h2d.Object;
import game.ui.TitleScreenOverlay;

interface TitleScreenOverlayFactory {
    public function createTitleScreenOverlay():TitleScreenOverlay;
}

class SimpleTitleScreenOverlayFactory extends BaseOverlayFactory implements TitleScreenOverlayFactory {

    private final boxFactory2d:BoxFactory2d;

    public function new(boxFactory2d:BoxFactory2d) {
        this.boxFactory2d = boxFactory2d;
    }

    public function createTitleScreenOverlay():TitleScreenOverlay {
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
        
        final font:Font = Res.fonts.hand_drawn_shapes_fnt.toFont();
        
        // big title
        final title:Text = this.createBasicText(font.clone());
        title.text = Constants.TITLE_SCREEN_TITLE;
        title.font.resizeTo(Constants.TITLE_FONT_SIZE);
        title.x = Constants.TITLE_X;
        title.y = Constants.TITLE_Y;
        overlayContainer.addChild(title);
        
        // flashing "begin" prompt
        final beginPrompt:Text = this.createBasicText(font.clone());
        beginPrompt.text = Constants.BEGIN_PROMPT_TEXT;
        beginPrompt.font.resizeTo(Constants.BEGIN_PROMPT_FONT_SIZE);
        beginPrompt.x = Constants.BEGIN_PROMPT_X;
        beginPrompt.y = Constants.BEGIN_PROMPT_Y;
        overlayContainer.addChild(beginPrompt);

        // tween tracker
        final tracker:TweenedAlpha = new TweenedAlpha(1., Constants.BEGIN_PROMPT_TOTAL_FRAMES);
        
        return new TitleScreenOverlay(overlayContainer, beginPrompt, tracker);
    }
}