part of stagexl_bitmapfont;

class _BitmapFontFormatFnt extends BitmapFontFormat {

  const _BitmapFontFormatFnt();

  @override
  Future<BitmapFont> load(BitmapFontLoader bitmapFontLoader) async {

    var source = await bitmapFontLoader.getSource();
    var pixelRatio = bitmapFontLoader.getPixelRatio();

    var argsRegExp = new RegExp(r'\s+(\w+)=((\-?\d+,?)+|".*?")');
    var lineRegExp = new RegExp(r'(\w+)((' + argsRegExp.pattern + r')+)');
    var splitRegExp = new RegExp(r'\r\n|\r|\n');

    BitmapFontInfo info;
    BitmapFontCommon common;
    List<BitmapFontPage> pages = new List<BitmapFontPage>();
    List<BitmapFontChar> chars = new List<BitmapFontChar>();
    List<BitmapFontKerning> kernings = new List<BitmapFontKerning>();

    for(var line in source.split(splitRegExp)) {

      var match = lineRegExp.firstMatch(line);
      if (match == null) continue;

      var chunk = match.group(1);
      var args = match.group(2);
      var argsMatch = argsRegExp.allMatches(args);
      var argsMap = _convertArgsMatches(argsMatch);

      if (chunk == "info") {

        var paddings = _getIntList(argsMap, "padding", [0, 0, 0, 0]);
        var spacings = _getIntList(argsMap, "spacing", [0, 0]);

        info = new BitmapFontInfo(
          _getString(argsMap, "face", ""),
          _getInt(argsMap, "size", 0),
          _getBool(argsMap, "bold", false),
          _getBool(argsMap, "italic", false),
          _getBool(argsMap, "unicode", false),
          _getBool(argsMap, "smooth", false),
          _getInt(argsMap, "outline", 0),
          _getInt(argsMap, "stretchH", 100),
          _getInt(argsMap, "aa", 1),
          _getString(argsMap, "charset", ""),
          paddings[0], paddings[1], paddings[2], paddings[3],
          spacings[0], spacings[1]);

      } else if (chunk == "common") {

        common = new BitmapFontCommon(
          _getInt(argsMap, "lineHeight", 0),
          _getInt(argsMap, "base", 0),
          _getInt(argsMap, "scaleW", 0),
          _getInt(argsMap, "scaleH", 0),
          _getInt(argsMap, "pages", 0),
          _getBool(argsMap, "packed", false),
          _getInt(argsMap, "alphaChnl", 0),
          _getInt(argsMap, "redChnl", 0),
          _getInt(argsMap, "greenChnl", 0),
          _getInt(argsMap, "blueChnl", 0));

      } else if (chunk == "page") {

        var id = _getInt(argsMap, "id", 0);
        var file = _getString(argsMap, "file", "");
        var bitmapData = await bitmapFontLoader.getBitmapData(id, file);
        pages.add(new BitmapFontPage(id, bitmapData));

      } else if (chunk == "char") {

        var id = _getInt(argsMap, "id", 0);
        var x = _getInt(argsMap, "x", 0);
        var y = _getInt(argsMap, "y", 0);
        var width = _getInt(argsMap, "width", 0);
        var height = _getInt(argsMap, "height", 0);
        var xOffset = _getInt(argsMap, "xoffset", 0);
        var yOffset = _getInt(argsMap, "yoffset", 0);
        var advance = _getInt(argsMap, "xadvance", 0);
        var pageId = _getInt(argsMap, "page", 0);
        var colorChannel = _getInt(argsMap, "chnl", 0);
        var letter = _getString(argsMap, "letter", "");

        var renderTextureQuad = new RenderTextureQuad.slice(
            pages.firstWhere((p) => p.id == pageId).bitmapData.renderTextureQuad,
            new Rectangle<int>(x, y, width, height),
            new Rectangle<int>(-xOffset, -yOffset, width, common.lineHeight));

        var bitmapData = new BitmapData.fromRenderTextureQuad(renderTextureQuad);
        chars.add(new BitmapFontChar(id, bitmapData, advance, colorChannel, letter));

      } else if (chunk == "kerning") {

        var first = _getInt(argsMap, "first", -1);
        var second = _getInt(argsMap, "second", -1);
        var amount = _getInt(argsMap, "amount", 0);
        kernings.add(new BitmapFontKerning(first, second, amount));
      }
    }

    return new BitmapFont(info, common, pages, chars, kernings, pixelRatio);
  }

  //---------------------------------------------------------------------------

  Map<String, String> _convertArgsMatches(Iterable<Match> matches) {
    var map = new Map<String, String>();
    matches.forEach((match) {
      map[match.group(1)] = match.group(2);
    });
    return map;
  }

  String _getString(Map map, String name, String defaultValue) {
    String value = map[name];
    if (value is! String) {
      return defaultValue;
    } else if (value.startsWith('"') && value.endsWith('"')) {
      return value.substring(1, value.length - 1);
    } else {
      return defaultValue;
    }
  }

  int _getInt(Map map, String name, int defaultValue) {
    String value = map[name];
    if (value is String) {
      return int.parse(value);
    } else {
      return defaultValue;
    }
  }

  bool _getBool(Map map, String name, bool defaultValue) {
    String value = map[name];
    if (value == null) return defaultValue;
    if (value == "1") return true;
    if (value == "0") return false;
    throw new FormatException("Error converting '$name' to bool.");
  }

  List<int> _getIntList(Map map, String name, List<int> defaultValue) {
    String value = map[name];
    if (value is String) {
      return value.split(",").map(int.parse).toList();
    } else {
      return defaultValue;
    }
  }

}
