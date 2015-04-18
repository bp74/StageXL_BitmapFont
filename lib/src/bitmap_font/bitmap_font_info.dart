part of stagexl_bitmapfont;

class BitmapFontInfo {

  /// This is the name of the true type font.
  final String face;

  /// The size of the true type font.
  final int size;

  /// The font is bold.
  final bool bold;

  /// The font is italic.
  final bool italic;

  /// Set to 1 if it is the unicode charset.
  final bool unicode;

  /// Set to 1 if smoothing was turned on.
  final bool smooth;

  /// The outline thickness for the characters
  final int outline;

  /// The font height stretch in percentage. 100% means no stretch.
  final int stretchHeight;

  /// The supersampling level used. 1 means no supersampling was used.
  final int superSampling;

  /// The name of the OEM charset used (when not unicode).
  final String charset;

  /// The left padding for the character.
  final int paddingLeft;

  /// The top padding for the character.
  final int paddingTop;

  /// The right padding for the character.
  final int paddingRight;

  /// The bottom padding for the character.
  final int paddingBottom;

  /// The horizontal spacing for the character.
  final int spacingHorizontal;

  /// The vertical spacing for the character.
  final int spacingVertical;

  //---------------------------------------------------------------------------

  BitmapFontInfo(
      this.face, this.size,
      this.bold, this.italic, this.unicode, this.smooth,
      this.outline, this.stretchHeight, this.superSampling, this.charset,
      this.paddingLeft, this.paddingTop, this.paddingRight, this.paddingBottom,
      this.spacingHorizontal, this.spacingVertical);

}
