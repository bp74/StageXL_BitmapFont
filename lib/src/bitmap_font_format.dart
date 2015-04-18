part of stagexl_bitmapfont;

// http://www.angelcode.com/products/bmfont/doc/file_format.html

abstract class BitmapFontFormat {

  static const BitmapFontFormat FNT = const _BitmapFontFormatFnt();
  static const BitmapFontFormat XML = const _BitmapFontFormatXml();
  static const BitmapFontFormat JSON = const _BitmapFontFormatJson();

  const BitmapFontFormat();

  Future<BitmapFont> load(String url, BitmapDataLoadOptions bitmapDataLoadOptions);
}
