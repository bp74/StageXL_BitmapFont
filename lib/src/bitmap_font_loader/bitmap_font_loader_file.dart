part of stagexl_bitmapfont;

class _BitmapFontLoaderFile extends BitmapFontLoader {

  final String sourceUrl;
  final BitmapDataLoadOptions bitmapDataLoadOptions;

  _BitmapFontLoaderFile(this.sourceUrl, this.bitmapDataLoadOptions);

  @override
  Future<String> getSource() {
    return HttpRequest.getString(this.sourceUrl);
  }

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    var regex = new RegExp(r"^(.*/)?(?:$|(.+?)(?:(\.[^.]*$)|$))");
    var path = regex.firstMatch(this.sourceUrl).group(1);
    var imageUrl = path == null ? filename : "$path$filename";
    return BitmapData.load(imageUrl, this.bitmapDataLoadOptions);
  }
}