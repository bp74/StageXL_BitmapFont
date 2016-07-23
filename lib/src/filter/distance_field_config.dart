part of stagexl_bitmapfont;

class DistanceFieldConfig {

  /// The threshold of the edge within the distance field.
  num threshold;

  /// The softness within the distance field when rendered at 100% scale.
  num softness;

  /// The outline within the distance field.
  num outline;

  //---------------------------------------------------------------------------

  DistanceFieldConfig({
    this.threshold: 0.5,
    this.softness: 0.25,
    this.outline: 0.25
  });

  DistanceFieldConfig clone() => new DistanceFieldConfig(
      threshold: this.threshold,
      softness: this.softness,
      outline: this.outline
  );

}