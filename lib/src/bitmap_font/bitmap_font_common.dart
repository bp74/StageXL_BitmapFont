part of stagexl_bitmapfont;

class BitmapFontCommon {

  /// This is the distance in pixels between each line of text.
  final int lineHeight;

  /// The number of pixels from the absolute top of the line to the base of
  /// the characters.
  final int base;

  /// The width of the texture, normally used to scale the x pos of the
  /// character image.
  final int scaleWidth;

  /// The height of the texture, normally used to scale the y pos of the
  /// character image.
  final int scaleHeight;

  /// The number of texture pages included in the font.
  final int pages;

  /// Set to 'true' if the monochrome characters have been packed into each of
  /// the texture channels. In this case alphaChannel describes what is stored
  /// in each channel.
  final bool packed;

  /// Set to 0 if the channel holds the glyph data, 1 if it holds the outline,
  /// 2 if it holds the glyph and the outline, 3 if its set to zero, and 4 if
  /// its set to one.
  final int alphaChannel;

  /// Set to 0 if the channel holds the glyph data, 1 if it holds the outline,
  /// 2 if it holds the glyph and the outline, 3 if its set to zero, and
  /// 4 if its set to one.
  final int redChannel;

  /// Set to 0 if the channel holds the glyph data, 1 if it holds the outline,
  /// 2 if it holds the glyph and the outline, 3 if its set to zero, and
  /// 4 if its set to one.
  final int greenChannel;

  /// Set to 0 if the channel holds the glyph data, 1 if it holds the outline,
  /// 2 if it holds the glyph and the outline, 3 if its set to zero, and
  /// 4 if its set to one.
  final int blueChannel;

  //---------------------------------------------------------------------------

  BitmapFontCommon(
      this.lineHeight, this.base, this.scaleWidth, this.scaleHeight, this.pages,
      this.alphaChannel, this.redChannel, this.greenChannel, this.blueChannel);

}
