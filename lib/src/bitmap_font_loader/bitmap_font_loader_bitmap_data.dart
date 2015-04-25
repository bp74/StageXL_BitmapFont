part of stagexl_bitmapfont;

class _BitmapFontLoaderBitmapData extends BitmapFontLoader {

  final String description;
  final BitmapData bitmapData;

  _BitmapFontLoaderBitmapData(this.description, this.bitmapData);

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