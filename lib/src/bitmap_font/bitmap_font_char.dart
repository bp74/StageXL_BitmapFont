part of stagexl_bitmapfont;

class BitmapFontChar {

  /// The character id.
  final int id;

  /// The left position of the character image in the texture.
  final int x;

  /// The top position of the character image in the texture.
  final int y;

  /// The width of the character image in the texture.
  final int width;

  /// The height of the character image in the texture.
  final int height;

  /// How much the current position should be offset when copying the
  /// image from the texture to the screen.
  final int xOffset;

  /// How much the current position should be offset when copying the
  /// image from the texture to the screen.
  final int yOffset;

  /// How much the current position should be advanced after drawing the character.
  final int xAdvance;

  /// The texture page where the character image is found.
  final int page;

  /// The texture channel where the character image is found.
  /// 1 = blue, 2 = green, 4 = red, 8 = alpha, 15 = all channels.
  final int colorChannel;

  /// The ASCII value of the character this line is describing. Helpful for debugging.
  final String letter;

  //-----------------------------------------------------------------------------------------------

  BitmapFontChar(
      this.id,
      this.x, this.y, this.width, this.height,
      this.xOffset, this.yOffset, this.xAdvance,
      this.page, this.colorChannel, this.letter);

}
