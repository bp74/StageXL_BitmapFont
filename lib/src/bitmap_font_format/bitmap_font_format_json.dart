part of stagexl_bitmapfont;

class _BitmapFontFormatJson extends BitmapFontFormat {

  const _BitmapFontFormatJson();

  Future<BitmapFont> load(BitmapFontLoader bitmapFontLoader) async {

    var source = await bitmapFontLoader.getSource();
    var data = JSON.decode(source);

    var infoPaddings = _getString(data, "padding", "0,0,0,0").split(",");
    var infoSpacings = _getString(data, "spacing", "0,0").split(",");

    var info = new BitmapFontInfo(
        _getString(data, "face", ""),
        _getInt(data, "size", 0),
        _getBool(data, "bold", false),
        _getBool(data, "italic", false),
        _getBool(data, "unicode", false),
        _getBool(data, "smooth", false),
        _getInt(data, "outline", 0),
        _getInt(data, "stretchH", 100),
        _getInt(data, "aa", 1),
        _getString(data, "charset", ""),
        int.parse(infoPaddings[0]),
        int.parse(infoPaddings[1]),
        int.parse(infoPaddings[2]),
        int.parse(infoPaddings[3]),
        int.parse(infoSpacings[0]),
        int.parse(infoSpacings[1]));

    var common = new BitmapFontCommon(
        _getInt(data, "lineHeight", 0),
        _getInt(data, "base", 0),
        _getInt(data, "scaleW", 0),
        _getInt(data, "scaleH", 0),
        _getInt(data, "pages", 0),
        _getBool(data, "packed", false),
        _getInt(data, "alphaChnl", 0),
        _getInt(data, "redChnl", 0),
        _getInt(data, "greenChnl", 0),
        _getInt(data, "blueChnl", 0));

    var pages = new List<BitmapFontPage>();
    var file = _getString(data, "file", "");
    var bitmapData = await bitmapFontLoader.getBitmapData(0, file);
    pages.add(new BitmapFontPage(0, bitmapData));

    var charMaps = data["chars"];
    if (charMaps == null) charMaps = new List();

    var chars = charMaps.map((charMap) {

      var id = _getInt(charMap, "id", 0);
      var pageId = _getInt(charMap, "page", 0);
      var advance = _getInt(charMap, "xadvance", 0);
      var colorChannel = _getInt(charMap, "chnl", 0);
      var letter = _getString(charMap, "letter", "");

      var page = pages.firstWhere((p) => p.id == pageId);
      var pageRenderTextureQuad = page.bitmapData.renderTextureQuad;
      var pixelRatio = pageRenderTextureQuad.pixelRatio;

      var x = (pixelRatio * _getInt(charMap, "x", 0)).round();
      var y = (pixelRatio * _getInt(charMap, "y", 0)).round();
      var width = (pixelRatio * _getInt(charMap, "width", 0)).round();
      var height = (pixelRatio * _getInt(charMap, "height", 0)).round();
      var xOffset = (pixelRatio * _getInt(charMap, "xoffset", 0)).round();
      var yOffset = (pixelRatio * _getInt(charMap, "yoffset", 0)).round();
      var lineHeight = (pixelRatio * common.lineHeight).round();

      var renderTextureQuad = new RenderTextureQuad.slice(
          pageRenderTextureQuad,
          new Rectangle<int>(x, y, width, height),
          new Rectangle<int>(-xOffset, -yOffset, width, lineHeight));

      var bitmapData = new BitmapData.fromRenderTextureQuad(renderTextureQuad);
      return new BitmapFontChar(id, bitmapData, advance, colorChannel, letter);

    }).toList();

    var kerningMaps = data["kernings"];
    if (kerningMaps == null) kerningMaps = new List();

    var kernings = kerningMaps.map((kerningMap) {
      var first = _getInt(kerningMap, "first", -1);
      var second = _getInt(kerningMap, "second", -1);
      var amount = _getInt(kerningMap, "amount", 0);
      return new BitmapFontKerning(first, second, amount);
    }).toList();

    return new BitmapFont(info, common, pages, chars, kernings);
  }

  //---------------------------------------------------------------------------

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
    if (value is int) {
      return value == 1;
    } else if (defaultValue is bool) {
      return defaultValue;
    } else {
      return false;
    }
  }
}
