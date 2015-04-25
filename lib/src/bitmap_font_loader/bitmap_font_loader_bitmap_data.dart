part of stagexl_bitmapfont;

class _BitmapFontLoaderBitmapData extends BitmapFontLoader {

  final BitmapData bitmapData;
  final String description;

  _BitmapFontLoaderBitmapData(this.bitmapData, this.description);

  @override
  Future<String> getDescription() {
    return new Future.value(this.description);
  }

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    if (id == 0) {
      return new Future.value(this.bitmapData);
    } else {
      throw new StateError("Only single BitmapData fonts are supported.");
    }
  }
}