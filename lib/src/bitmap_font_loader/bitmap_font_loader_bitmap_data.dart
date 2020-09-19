part of stagexl_bitmapfont;

class _BitmapFontLoaderBitmapData extends BitmapFontLoader {
  final BitmapData bitmapData;
  final String source;

  _BitmapFontLoaderBitmapData(this.bitmapData, this.source);

  //----------------------------------------------------------------------------

  @override
  double getPixelRatio() => bitmapData.renderTextureQuad.pixelRatio;

  @override
  Future<String> getSource() => Future.value(source);

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    if (id == 0) {
      return Future.value(bitmapData);
    } else {
      throw StateError('Only single BitmapData fonts are supported.');
    }
  }
}
