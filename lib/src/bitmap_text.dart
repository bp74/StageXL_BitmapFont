part of stagexl_bitmapfont;

/// The [BitmapText] is a standard [Bitmap] display object, which generates a
/// a custom [BitmapData] object for a given [text].
///
/// To achieve this, a [RenderTextureQuad] with custom vertices is generated.
/// Please be aware that this is very fast with the WebGL renderer, but slow
/// with the Canvas2D renderer. If you target Canvas2D you should use the
/// [BitmapContainerText] display object.

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

  set text(String value) {
    _text = value;
    if (value == "") {
      this.bitmapData = null;
    } else {
      var renderTextureQuad = this.bitmapFont.createRenderTextureQuad(text);
      this.bitmapData = new BitmapData.fromRenderTextureQuad(renderTextureQuad);
    }
  }

}