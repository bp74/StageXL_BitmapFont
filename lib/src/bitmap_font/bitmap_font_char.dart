part of stagexl_bitmapfont;

class BitmapFontChar {

  /// The character id.
  final int id;

  /// The BitmapData containing the glyph.
  final BitmapData bitmapData;

  /// How much the current position should be advanced after drawing the character.
  final int advance;

  /// The texture channel where the character image is found.
  /// 1 = blue, 2 = green, 4 = red, 8 = alpha, 15 = all channels.
  final int colorChannel;

  /// The ASCII value of the character this line is describing. Helpful for debugging.
  final String letter;

  //-----------------------------------------------------------------------------------------------

  BitmapFontChar(
      this.id, this.bitmapData, this.advance,
      this.colorChannel, this.letter);

}
