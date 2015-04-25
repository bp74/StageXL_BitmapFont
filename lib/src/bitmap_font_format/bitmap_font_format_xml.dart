part of stagexl_bitmapfont;

class _BitmapFontFormatXml extends BitmapFontFormat {

  const _BitmapFontFormatXml();

  Future<BitmapFont> load(BitmapFontLoader bitmapFontLoader) async {

    var definition = await bitmapFontLoader.getDefinition();
    var xml = parse(definition);
    var fontXml = xml.findElements("font").first;
    var infoXml = fontXml.findElements("info").first;
    var commonXml = fontXml.findElements("common").first;
    var pageXmls = fontXml.findAllElements("page");
    var charXmls = fontXml.findAllElements("char");
    var kerningXmls = fontXml.findAllElements("kerning");

    var infoPaddings = _getString(infoXml, "padding", "0,0,0,0").split(",");
    var infoSpacings = _getString(infoXml, "spacing", "0,0").split(",");

    var info = new BitmapFontInfo(
        _getString(infoXml, "face", ""),
        _getInt(infoXml, "size", 0),
        _getBool(infoXml, "bold", false),
        _getBool(infoXml, "italic", false),
        _getBool(infoXml, "unicode", false),
        _getBool(infoXml, "smooth", false),
        _getInt(infoXml, "outline", 0),
        _getInt(infoXml, "stretchH", 100),
        _getInt(infoXml, "aa", 1),
        _getString(infoXml, "charset", ""),
        int.parse(infoPaddings[0]),
        int.parse(infoPaddings[1]),
        int.parse(infoPaddings[2]),
        int.parse(infoPaddings[3]),
        int.parse(infoSpacings[0]),
        int.parse(infoSpacings[1]));

    var common = new BitmapFontCommon(
        _getInt(commonXml, "lineHeight", 0),
        _getInt(commonXml, "base", 0),
        _getInt(commonXml, "scaleW", 0),
        _getInt(commonXml, "scaleH", 0),
        _getInt(commonXml, "pages", 0),
        _getBool(commonXml, "packed", false),
        _getInt(commonXml, "alphaChnl", 0),
        _getInt(commonXml, "redChnl", 0),
        _getInt(commonXml, "greenChnl", 0),
        _getInt(commonXml, "blueChnl", 0));

    var futurePages = pageXmls.map((pageXml) async {
      var id = _getInt(pageXml, "id", 0);
      var file = _getString(pageXml, "file", "");
      var bitmapData = await bitmapFontLoader.getBitmapData(id, file);
      return new BitmapFontPage(id, bitmapData);
    });

    var pages = await Future.wait(futurePages);

    var chars = charXmls.map((charXml) {

      var id = _getInt(charXml, "id", 0);
      var x = _getInt(charXml, "x", 0);
      var y = _getInt(charXml, "y", 0);
      var width = _getInt(charXml, "width", 0);
      var height = _getInt(charXml, "height", 0);
      var xOffset = _getInt(charXml, "xoffset", 0);
      var yOffset = _getInt(charXml, "yoffset", 0);
      var advance = _getInt(charXml, "xadvance", 0);
      var pageId = _getInt(charXml, "page", 0);
      var colorChannel = _getInt(charXml, "chnl", 0);
      var letter = _getString(charXml, "letter", "");

      var renderTextureQuad = new RenderTextureQuad.slice(
          pages.firstWhere((p) => p.id == pageId).bitmapData.renderTextureQuad,
          new Rectangle<int>(x, y, width, height),
          new Rectangle<int>(-xOffset, -yOffset, width, common.lineHeight));

      var bitmapData = new BitmapData.fromRenderTextureQuad(renderTextureQuad);
      return new BitmapFontChar(id, bitmapData, advance, colorChannel, letter);

    }).toList();

    var kernings = kerningXmls.map((kerningXml) {
      var first = _getInt(kerningXml, "first", -1);
      var second = _getInt(kerningXml, "second", -1);
      var amount = _getInt(kerningXml, "amount", 0);
      return new BitmapFontKerning(first, second, amount);
    }).toList();

    return new BitmapFont(info, common, pages, chars, kernings);
  }

  //---------------------------------------------------------------------------

  String _getAtttributeValue(XmlElement xml, String name) {
    for(var attribute in xml.attributes) {
      if (attribute.name.local == name) return attribute.value;
    }
    return null;
  }

  String _getString(XmlElement xml, String name, String defaultValue) {
    var value = _getAtttributeValue(xml, name);
    return value is String ? value : defaultValue;
  }

  int _getInt(XmlElement xml, String name, int defaultValue) {
    var value = _getAtttributeValue(xml, name);
    return value is String ? int.parse(value) : defaultValue;
  }

  bool _getBool(XmlElement xml, String name, bool defaultValue) {
    var value = _getAtttributeValue(xml, name);
    if (value == null) return defaultValue;
    if (value == "1") return true;
    if (value == "0") return false;
    throw new FormatException("Error converting '$name' to bool.");
  }
}