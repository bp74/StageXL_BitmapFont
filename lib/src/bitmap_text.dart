part of stagexl_bitmapfont;

class BitmapText extends Bitmap {

  final BitmapFont bitmapFont;
  String _text = "";

  BitmapText(this.bitmapFont) : super() {
    if (bitmapFont.pages.length > 1) {
      throw new ArgumentError("Use BitmapContainerText for multi page fonts.");
    }
  }

  //---------------------------------------------------------------------------

  String get text => _text;

  void set text(String value) {

    _text = value;

    if (value == "") {
      this.bitmapData = null;
      return;
    }

    int ixOffset = 0;
    int lastCodeUnit = 0;
    int x = 0, y = 0, maxX = 0;

    var lineSplit = new RegExp(r"\r\n|\r|\n");
    var vxData = new List<double>();
    var ixData = new List<int>();

    for (String line in value.split(lineSplit)) {

      for (int codeUnit in line.codeUnits) {

        var kerning = bitmapFont.getKerningAmount(lastCodeUnit, codeUnit);
        var bitmapFontChar = bitmapFont.getChar(codeUnit);
        if (bitmapFontChar == null) continue;

        var charQuad = bitmapFontChar.bitmapData.renderTextureQuad;
        var charVxList = charQuad.vxList;
        var charIxList = charQuad.ixList;

        for (int i = 0; i < charIxList.length; i++) {
          ixData.add(ixOffset + charIxList[i]);
        }

        for (int i = 0; i <= charVxList.length - 4; i += 4) {
          vxData.add(charVxList[i + 0] + x + kerning);
          vxData.add(charVxList[i + 1] + y);
          vxData.add(charVxList[i + 2]);
          vxData.add(charVxList[i + 3]);
          ixOffset += 1;
        }

        x = x + bitmapFontChar.advance + kerning;
        lastCodeUnit = codeUnit;
      }

      maxX = x > maxX ? x : maxX;
      lastCodeUnit = 0;
      x = 0;
      y = y + bitmapFont.common.lineHeight;
    }

    var bounds = new Rectangle<num>(0, 0, maxX, y);
    var renderTexture = bitmapFont.pages[0].bitmapData.renderTexture;
    var renderTextureQuad = renderTexture.quad.cut(bounds);
    var vxList = new Float32List.fromList(vxData);
    var ixList = new Int16List.fromList(ixData);
    renderTextureQuad.setCustomVertices(vxList, ixList);
    this.bitmapData = new BitmapData.fromRenderTextureQuad(renderTextureQuad);
  }

}