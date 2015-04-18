part of stagexl_bitmapfont;

class BitmapFontPage {

  /// The page id.
  final int id;

  /// The RenderTexture containing the glyphs.
  final BitmapData bitmapData;

  //---------------------------------------------------------------------------

  BitmapFontPage(this.id, this.bitmapData);

}
