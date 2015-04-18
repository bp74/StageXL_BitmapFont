part of stagexl_bitmapfont;

class _BitmapFontFormatJson extends BitmapFontFormat {

  const _BitmapFontFormatJson();

  Future<BitmapFont> load(String url, BitmapDataLoadOptions bitmapDataLoadOptions) async {

    throw new UnimplementedError("");

  }

  String _getString(Map map, String name, String defaultValue) {
    var value = map[name];
    return value is String ? value : defaultValue;
  }

  int _getInt(Map map, String name, int defaultValue) {
    var value = map[name];
    if (value is int) {
      return value;
    } else if (defaultValue is int) {
      return defaultValue;
    } else {
      return 0;
    }
  }

  bool _getBool(Map map, String name, bool defaultValue) {
    var value = map[name];
    if (value is bool) {
      return value;
    } else if (defaultValue is bool) {
      return defaultValue;
    } else {
      return false;
    }
  }
}
