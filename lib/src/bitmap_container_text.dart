part of stagexl_bitmapfont;

class BitmapContainerText extends DisplayObjectContainer {
  final BitmapFont bitmapFont;
  String _text = '';

  BitmapContainerText(this.bitmapFont);

  //---------------------------------------------------------------------------

  String get text => _text;

  set text(String value) {
    removeChildren();
    _text = value;

    var x = 0.0;
    var y = 0.0;
    var scale = 1.0 / bitmapFont.pixelRatio;
    var lastCodeUnit = 0;

    var lineSplit = RegExp(r'\r\n|\r|\n');

    for (var line in value.split(lineSplit)) {
      for (var codeUnit in line.codeUnits) {
        var bitmapFontChar = bitmapFont.getChar(codeUnit);
        if (bitmapFontChar != null) {
          x += scale * bitmapFont.getKerningAmount(lastCodeUnit, codeUnit);
          var bitmap = Bitmap(bitmapFontChar.bitmapData);
          bitmap.x = x;
          bitmap.y = y;
          bitmap.addTo(this);
          x += scale * bitmapFontChar.advance;
          lastCodeUnit = codeUnit;
        }
      }
      lastCodeUnit = 0;
      x = 0.0;
      y = y + scale * bitmapFont.common.lineHeight;
    }
  }
}
