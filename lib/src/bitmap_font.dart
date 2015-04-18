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
    BitmapDataLoadOptions bitmapDataLoadOptions]) {

    return bitmapFontFormat.load(url, bitmapDataLoadOptions);
  }

  //-----------------------------------------------------------------------------------------------




}
