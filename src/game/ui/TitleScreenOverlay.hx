package game.ui;

import game.data.mutable.tweens.TweenedAlpha;
import h2d.Object;

@:build(macros.RecordClassMacro.Record.build())
class TitleScreenOverlay {

    var overlayContainer:Object;
    var beginPromptText:Object;
    var promptAlpha:TweenedAlpha;
}