part of stagexl_bitmapfont;

class BitmapContainerText extends DisplayObjectContainer {

  final BitmapFont bitmapFont;
  String _text = "";

  BitmapContainerText(this.bitmapFont);

  //---------------------------------------------------------------------------

  String get text => _text;

  void set text(String value) {

    this.removeChildren();
    _text = value;

    int x = 0, y = 0, lastCodeUnit = 0;
    RegExp lineSplit = new RegExp(r"\r\n|\r|\n");

    for(String line in value.split(lineSplit)) {
      for(int codeUnit in line.codeUnits) {
        var kerning = bitmapFont.getKerningAmount(lastCodeUnit, codeUnit);
        var bitmapFontChar = bitmapFont.getChar(codeUnit);
        if (bitmapFontChar != null) {
          var bitmap = new Bitmap(bitmapFontChar.bitmapData);
          bitmap.x = x + kerning;
          bitmap.y = y;
          bitmap.addTo(this);
          x = x + bitmapFontChar.advance + kerning;
          lastCodeUnit = codeUnit;
        }
      }
      lastCodeUnit = 0;
      x = 0;
      y = y + bitmapFont.common.lineHeight;
    }
  }


}