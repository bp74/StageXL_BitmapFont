part of stagexl_bitmapfont;

class _BitmapFontLoaderTextureAtlas extends BitmapFontLoader {
  final TextureAtlas textureAtlas;
  final String namePrefix;
  final String source;

  _BitmapFontLoaderTextureAtlas(
      this.textureAtlas, this.namePrefix, this.source);

  //----------------------------------------------------------------------------

  @override
  double getPixelRatio() => textureAtlas.pixelRatio;

  @override
  Future<String> getSource() => Future.value(source);

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    var regex = RegExp(r'(.+?)(\.[^.]*$|$)');
    var match = regex.firstMatch(filename);
    var name = namePrefix + match.group(1);
    return Future.value(textureAtlas.getBitmapData(name));
  }
}
