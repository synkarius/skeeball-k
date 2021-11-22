package factories.ui;

import resources.Constants;
import h2d.Text;
import h2d.Font;

class BaseOverlayFactory {

    private function createBasicText(font:Font):Text {
        final text:Text = new Text(font);
        text.textColor = Constants.COLOR_BLACK;
        text.smooth = true;
        text.textAlign = Align.Left;
        text.alpha = Constants.TITLE_ALPHA;
        return text;
    }
}