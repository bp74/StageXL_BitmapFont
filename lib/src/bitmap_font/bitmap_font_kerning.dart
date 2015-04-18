part of stagexl_bitmapfont;

class BitmapFontKerning {

  /// The first character id.
  final int first;

  /// The second character id.
  final int second;

  /// How much the x position should be adjusted when drawing
  /// the second character immediately following the first.
  final int amount;

  //---------------------------------------------------------------------------

  BitmapFontKerning(this.first, this.second, this.amount);

}
