part of stagexl_bitmapfont;

/// The base class for a custom bitmap font loader.
///
/// Use the [BitmapFont.withLoader] function to load a bitmap font
/// from a custom source by implementing a BitmapFontLoader class.

abstract class BitmapFontLoader {
  Future<String> getDefinition();
  Future<BitmapData> getBitmapData(int id, String filename);
}

//-----------------------------------------------------------------------------
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
  Future<BitmapData> getBitmapData(int id, String filename) {
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
  Future<BitmapData> getBitmapData(int id, String filename) {
    var regex = new RegExp(r"(.+?)(\.[^.]*$|$)");
    var match = regex.firstMatch(filename);
    var name = match.group(1);
    return new Future.value(this.textureAtlas.getBitmapData(name));
  }
}

//-----------------------------------------------------------------------------

class _BitmapDataBitmapFontLoader extends BitmapFontLoader {

  final String definition;
  final BitmapData bitmapData;

  _BitmapDataBitmapFontLoader(this.definition, this.bitmapData);

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
