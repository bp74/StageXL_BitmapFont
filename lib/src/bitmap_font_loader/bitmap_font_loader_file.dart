part of stagexl_bitmapfont;

class _BitmapFontLoaderFile extends BitmapFontLoader {

  final BitmapDataLoadOptions bitmapDataLoadOptions;
  final String url;

  _BitmapFontLoaderFile(this.url, this.bitmapDataLoadOptions);

  @override
  Future<String> getDefinition() {
    return HttpRequest.getString(this.url);
  }

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    var regex = new RegExp(r"^(.*/)?(?:$|(.+?)(?:(\.[^.]*$)|$))");
    var path = regex.firstMatch(url).group(1);
    var imageUrl = path == null ? filename : "$path$filename";
    return BitmapData.load(imageUrl, this.bitmapDataLoadOptions);
  }
}