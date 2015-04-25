part of stagexl_bitmapfont;

class _BitmapFontLoaderTextureAtlas extends BitmapFontLoader {

  final TextureAtlas textureAtlas;
  final String namePrefix;
  final String source;

  _BitmapFontLoaderTextureAtlas(this.textureAtlas, this.namePrefix, this.source);

  @override
  Future<String> getSource() {
    return new Future.value(this.source);
  }

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    var regex = new RegExp(r"(.+?)(\.[^.]*$|$)");
    var match = regex.firstMatch(filename);
    var name = this.namePrefix + match.group(1);
    return new Future.value(this.textureAtlas.getBitmapData(name));
  }
}