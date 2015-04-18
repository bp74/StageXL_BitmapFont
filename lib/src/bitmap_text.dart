part of stagexl_bitmapfont;

class BitmapText extends DisplayObjectContainer {

  final BitmapFont bitmapFont;
  String _text = "";

  BitmapText(this.bitmapFont);

  //---------------------------------------------------------------------------

  String get text => _text;

  void set text(String value) {

    this.removeChildren();
    _text = value.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    int x = 0, y = 0, lastCodeUnit = 0;

    for(String line in _text.split('\n')) {
      for(int codeUnit in line.codeUnits) {
        var kerning = bitmapFont.getKerningAmount(lastCodeUnit, codeUnit);
        var bitmapFontChar = bitmapFont.getChar(codeUnit);
        var bitmapData = bitmapFontChar.bitmapData;
        var bitmap = new Bitmap(bitmapData);
        bitmap.x = x + kerning;
        bitmap.y = y;
        bitmap.addTo(this);
        x = x + bitmapFontChar.advance + kerning;
        lastCodeUnit = codeUnit;
      }
      lastCodeUnit = 0;
      x = 0;
      y = y + bitmapFont.common.lineHeight;
    }
  }


}