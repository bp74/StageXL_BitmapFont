part of stagexl_bitmapfont;

class _BitmapFontLoaderBitmapData extends BitmapFontLoader {

  final BitmapData bitmapData;
  final String source;

  _BitmapFontLoaderBitmapData(this.bitmapData, this.source);

  //----------------------------------------------------------------------------

  @override
  double getPixelRatio() => this.bitmapData.renderTextureQuad.pixelRatio;

  @override
  Future<String> getSource() => new Future.value(this.source);

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    if (id == 0) {
      return new Future.value(this.bitmapData);
    } else {
      throw new StateError("Only single BitmapData fonts are supported.");
    }
  }
}
