part of stagexl_bitmapfont;

class _BitmapFontLoaderFile extends BitmapFontLoader {

  String sourceUrl;
  BitmapDataLoadOptions bitmapDataLoadOptions;
  double pixelRatio;

  _BitmapFontLoaderFile(String sourceUrl, BitmapDataLoadOptions options) {

    options = options ?? BitmapData.defaultLoadOptions;
    var fileInfo = new BitmapDataLoadInfo(sourceUrl, options.pixelRatios);

    this.sourceUrl = fileInfo.loaderUrl;
    this.pixelRatio = fileInfo.pixelRatio;
    this.bitmapDataLoadOptions = options;
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
