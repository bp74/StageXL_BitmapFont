part of stagexl_bitmapfont;

/// The base class for a custom bitmap font loader.
///
/// Use the [BitmapFont.withLoader] function to load a bitmap font
/// from a custom source by implementing a BitmapFontLoader class.

abstract class BitmapFontLoader {

  /// Get the source of the bitmap font.
  Future<String> getSource();

  /// Get the BitmapData for a bitmap font page.
  Future<BitmapData> getBitmapData(int id, String filename);

  /// Get the pixel ratio of the font that is loaded.
  double getPixelRatio();
}
