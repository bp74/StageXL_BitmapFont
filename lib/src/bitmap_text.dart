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
    } else {
      var renderTextureQuad = this.bitmapFont.createRenderTextureQuad(text);
      this.bitmapData = new BitmapData.fromRenderTextureQuad(renderTextureQuad);
    }
  }

}