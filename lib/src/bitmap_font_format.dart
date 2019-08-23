part of stagexl_bitmapfont;

// http://www.angelcode.com/products/bmfont/doc/file_format.html

abstract class BitmapFontFormat {

  static const BitmapFontFormat FNT = _BitmapFontFormatFnt();
  static const BitmapFontFormat XML = _BitmapFontFormatXml();
  static const BitmapFontFormat JSON = _BitmapFontFormatJson();

  const BitmapFontFormat();

  Future<BitmapFont> load(BitmapFontLoader bitmapFontLoader);
}
