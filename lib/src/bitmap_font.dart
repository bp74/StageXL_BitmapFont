part of stagexl_bitmapfont;

class BitmapFont {

  /// Information on how the font was generated.
  final BitmapFontInfo info;

  /// Information common to all characters.
  final BitmapFontCommon common;

  /// The pages (textures) used for this characters.
  final List<BitmapFontPage> pages;

  /// The characters in the font.
  final List<BitmapFontChar> chars;

  /// The kerning information is used to adjust the distance between certain characters,
  /// e.g. some characters should be placed closer to each other than others.
  final List<BitmapFontKerning> kernings;

  BitmapFont(this.info, this.common, this.pages, this.chars, this.kernings);

  //-----------------------------------------------------------------------------------------------

  static Future<BitmapFont> load(String url, [
      BitmapFontFormat bitmapFontFormat = BitmapFontFormat.FNT,
      BitmapDataLoadOptions bitmapDataLoadOptions = null]) {

    if (bitmapDataLoadOptions == null) {
      bitmapDataLoadOptions = BitmapData.defaultLoadOptions;
    }

    var loader = new _BitmapFontLoaderFile(url, bitmapDataLoadOptions);
    return bitmapFontFormat.load(loader);
  }

  static Future<BitmapFont> fromTextureAtlas(
      String definition, TextureAtlas textureAtlas, [
      BitmapFontFormat bitmapFontFormat = BitmapFontFormat.FNT]) {

    var loader = new _BitmapFontLoaderTextureAtlas(definition, textureAtlas);
    return bitmapFontFormat.load(loader);
  }

  static Future<BitmapFont> fromBitmapData(
      String definition, BitmapData bitmapData, [
      BitmapFontFormat bitmapFontFormat = BitmapFontFormat.FNT]) {

    var loader = new _BitmapFontLoaderBitmapData(definition, bitmapData);
    return bitmapFontFormat.load(loader);
  }

  static Future<BitmapFont> withLoader(
      BitmapFontLoader bitmapFontLoader, [
      BitmapFontFormat bitmapFontFormat = BitmapFontFormat.FNT]) {

    return bitmapFontFormat.load(bitmapFontLoader);
  }

  //-----------------------------------------------------------------------------------------------

  BitmapFontChar getChar(int id) {
    for(int i = 0; i < this.chars.length; i++) {
      var char = this.chars[i];
      if (char.id == id) return char;
    }
    return null;
  }

  BitmapFontKerning getKerning(int first, int second) {
    for(int i = 0; i < this.kernings.length; i++) {
      var kerning = this.kernings[i];
      if (kerning.first == first && kerning.second == second) {
        return kerning;
      }
    }
    return null;
  }

  int getKerningAmount(int first, int second) {
    var kerning = getKerning(first, second);
    return kerning != null ? kerning.amount : 0;
  }

}
