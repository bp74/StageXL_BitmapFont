part of stagexl_bitmapfont;

class _BitmapFontLoaderTextureAtlas extends BitmapFontLoader {

  final String definition;
  final TextureAtlas textureAtlas;

  _BitmapFontLoaderTextureAtlas(this.definition, this.textureAtlas);

  @override
  Future<String> getDefinition() {
    return new Future.value(this.definition);
  }

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    var regex = new RegExp(r"(.+?)(\.[^.]*$|$)");
    var match = regex.firstMatch(filename);
    var name = match.group(1);
    return new Future.value(this.textureAtlas.getBitmapData(name));
  }
}