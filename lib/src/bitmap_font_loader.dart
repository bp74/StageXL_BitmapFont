part of stagexl_bitmapfont;

/// The base class for a custom bitmap font loader.
///
/// Use the [BitmapFont.withLoader] function to load a bitmap font
/// from a custom source by implementing a BitmapFontLoader class.

abstract class BitmapFontLoader {
  Future<String> getDefinition();
  Future<BitmapData> getBitmapData(int id, String filename);
}
