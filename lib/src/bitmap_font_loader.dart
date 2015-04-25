part of stagexl_bitmapfont;

/// The base class for a custom BitmapFontLoader.

abstract class BitmapFontLoader {
  Future<String> getDefinition();
  Future<BitmapData> getBitmapData(String filename);
}

//-----------------------------------------------------------------------------

class _FileBitmapFontLoader extends BitmapFontLoader {

  final BitmapDataLoadOptions bitmapDataLoadOptions;
  final String url;

  _FileBitmapFontLoader(this.url, this.bitmapDataLoadOptions);

  @override
  Future<String> getDefinition() {
    return HttpRequest.getString(this.url);
  }

  @override
  Future<BitmapData> getBitmapData(String filename) {
    var regex = new RegExp(r"^(.*/)?(?:$|(.+?)(?:(\.[^.]*$)|$))");
    var path = regex.firstMatch(url).group(1);
    var imageUrl = path == null ? filename : "$path$filename";
    return BitmapData.load(imageUrl, this.bitmapDataLoadOptions);
  }
}

//-----------------------------------------------------------------------------

class _TextureAtlasBitmapFontLoader extends BitmapFontLoader {

  final String definition;
  final TextureAtlas textureAtlas;

  _TextureAtlasBitmapFontLoader(this.definition, this.textureAtlas);

  @override
  Future<String> getDefinition() {
    return new Future.value(this.definition);
  }

  @override
  Future<BitmapData> getBitmapData(String filename) {
    var regex = new RegExp(r"(.+?)(\.[^.]*$|$)");
    var match = regex.firstMatch(filename);
    var name = match.group(1);
    return new Future.value(this.textureAtlas.getBitmapData(name));
  }
}
