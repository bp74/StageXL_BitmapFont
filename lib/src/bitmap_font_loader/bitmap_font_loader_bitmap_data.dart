part of stagexl_bitmapfont;

class _BitmapFontLoaderBitmapData extends BitmapFontLoader {

  final String definition;
  final BitmapData bitmapData;

  _BitmapFontLoaderBitmapData(this.definition, this.bitmapData);

  @override
  Future<String> getDefinition() {
    return new Future.value(this.definition);
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