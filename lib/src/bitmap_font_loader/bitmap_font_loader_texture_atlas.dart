part of stagexl_bitmapfont;

class _BitmapFontLoaderTextureAtlas extends BitmapFontLoader {

  final String description;
  final TextureAtlas textureAtlas;

  _BitmapFontLoaderTextureAtlas(this.description, this.textureAtlas);

  @override
  Future<String> getDescription() {
    return new Future.value(this.description);
  }

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    var regex = new RegExp(r"(.+?)(\.[^.]*$|$)");
    var match = regex.firstMatch(filename);
    var name = match.group(1);
    return new Future.value(this.textureAtlas.getBitmapData(name));
  }
}