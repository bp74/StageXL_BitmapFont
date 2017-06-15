part of stagexl_bitmapfont;

class _BitmapFontLoaderFile extends BitmapFontLoader {

  String sourceUrl;
  BitmapDataLoadOptions bitmapDataLoadOptions;
  double pixelRatio;

  _BitmapFontLoaderFile(String sourceUrl, BitmapDataLoadOptions options) {

    options = options ?? BitmapData.defaultLoadOptions;

    this.sourceUrl = sourceUrl;
    this.bitmapDataLoadOptions = options;
    this.pixelRatio = 1.0;

    var pixelRatioRegexp = new RegExp(r"@(\d+(.\d+)?)x");
    var pixelRatioMatch = pixelRatioRegexp.firstMatch(sourceUrl);

    if (pixelRatioMatch != null) {
      var match = pixelRatioMatch;
      var originPixelRatioFractions = (match.group(2) ?? ".").length - 1;
      var originPixelRatio = double.parse(match.group(1));
      var devicePixelRatio = StageXL.environment.devicePixelRatio;
      var loaderPixelRatio = options.pixelRatios.fold<num>(0.0, (num a, num b) {
        var aDelta = (a - devicePixelRatio).abs();
        var bDelta = (b - devicePixelRatio).abs();
        return aDelta < bDelta && a > 0.0 ? a : b;
      });
      var name = loaderPixelRatio.toStringAsFixed(originPixelRatioFractions);
      this.sourceUrl = sourceUrl.replaceRange(match.start + 1, match.end - 1, name);
      this.pixelRatio = loaderPixelRatio / originPixelRatio;
    }
  }

  //----------------------------------------------------------------------------

  @override
  double getPixelRatio() => this.pixelRatio;

  @override
  Future<String> getSource() => HttpRequest.getString(this.sourceUrl);

  @override
  Future<BitmapData> getBitmapData(int id, String filename) async {
    var regex = new RegExp(r"^(.*/)?(?:$|(.+?)(?:(\.[^.]*$)|$))");
    var path = regex.firstMatch(this.sourceUrl).group(1);
    var imageUrl = path == null ? filename : "$path$filename";
    var bitmap = await BitmapData.load(imageUrl, this.bitmapDataLoadOptions);
    var renderTextureQuad = bitmap.renderTextureQuad.withPixelRatio(pixelRatio);
    return new BitmapData.fromRenderTextureQuad(renderTextureQuad);
  }
}
