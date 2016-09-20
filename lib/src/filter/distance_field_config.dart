part of stagexl_bitmapfont;

/// Configuration of a distance field.
///
/// A distance field contains values from 0.0 to 1.0. The values correspond to
/// the distance of each pixel to the nearest edge. A value of 0.5 means that
/// the pixel is right at the edge.

class DistanceFieldConfig {

  /// The threshold of the edge within the distance field.

  num threshold;

  /// The softness of the edge within the distance field when rendered at
  /// 100% scale. The softness is applied inverse proportional to the scale.

  num softness;

  //---------------------------------------------------------------------------

  DistanceFieldConfig([this.threshold = 0.5, this.softness = 0.25]);

  DistanceFieldConfig clone() {
    return new DistanceFieldConfig(this.threshold, this.softness);
  }

}
