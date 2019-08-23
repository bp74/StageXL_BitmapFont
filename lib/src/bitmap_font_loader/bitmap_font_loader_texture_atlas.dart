part of stagexl_bitmapfont;

class _BitmapFontLoaderTextureAtlas extends BitmapFontLoader {

  final TextureAtlas textureAtlas;
  final String namePrefix;
  final String source;

  _BitmapFontLoaderTextureAtlas(this.textureAtlas, this.namePrefix, this.source);

  //----------------------------------------------------------------------------

  @override
  double getPixelRatio() => this.textureAtlas.pixelRatio;

  @override
  Future<String> getSource() => Future.value(this.source);

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    var regex = RegExp(r"(.+?)(\.[^.]*$|$)");
    var match = regex.firstMatch(filename);
    var name = this.namePrefix + match.group(1);
    return Future.value(this.textureAtlas.getBitmapData(name));
  }
}
