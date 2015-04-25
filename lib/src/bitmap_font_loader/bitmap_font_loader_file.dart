part of stagexl_bitmapfont;

class _BitmapFontLoaderFile extends BitmapFontLoader {

  final String descriptionUrl;
  final BitmapDataLoadOptions bitmapDataLoadOptions;

  _BitmapFontLoaderFile(this.descriptionUrl, this.bitmapDataLoadOptions);

  @override
  Future<String> getDescription() {
    return HttpRequest.getString(this.descriptionUrl);
  }

  @override
  Future<BitmapData> getBitmapData(int id, String filename) {
    var regex = new RegExp(r"^(.*/)?(?:$|(.+?)(?:(\.[^.]*$)|$))");
    var path = regex.firstMatch(this.descriptionUrl).group(1);
    var imageUrl = path == null ? filename : "$path$filename";
    return BitmapData.load(imageUrl, this.bitmapDataLoadOptions);
  }
}