part of stagexl_bitmapfont;

class _BitmapFontFormatXml extends BitmapFontFormat {

  const _BitmapFontFormatXml();

  Future<BitmapFont> load(String url, BitmapDataLoadOptions bitmapDataLoadOptions) async {

    if (bitmapDataLoadOptions == null) {
      bitmapDataLoadOptions = BitmapData.defaultLoadOptions;
    }

    // TODO: add support for HiDpi textures

    var xmlText = await HttpRequest.getString(url);
    var xml = parse(xmlText);
    var fontXml = xml.findElements("font").first;
    var infoXml = fontXml.findElements("info").first;
    var commonXml = fontXml.findElements("common").first;
    var pagesXml = fontXml.findElements("pages").first;
    var charsXml = fontXml.findElements("chars").first;
    var kerningsXml = fontXml.findElements("kernings").first;

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

    var pages = pagesXml.findElements("page").map((pageXml) {
      var id = _getInt(pageXml, "id", 0);
      var file = _getString(pageXml, "file", "");
      return new BitmapFontPage(id, file);
    }).toList();

    var chars = charsXml.findElements("char").map((charXml) {
      var id = _getInt(charXml, "id", 0);
      var x = _getInt(charXml, "x", 0);
      var y = _getInt(charXml, "y", 0);
      var width = _getInt(charXml, "width", 0);
      var height = _getInt(charXml, "height", 0);
      var xOffset = _getInt(charXml, "xoffset", 0);
      var yOffset = _getInt(charXml, "yoffset", 0);
      var xAdvance = _getInt(charXml, "xadvance", 0);
      var page = _getInt(charXml, "page", 0);
      var colorChannel = _getInt(charXml, "chnl", 0);
      var letter = _getString(charXml, "letter", "");
      return new BitmapFontChar(
          id, x, y, width, height, xOffset, yOffset,
          xAdvance, page, colorChannel, letter);
    }).toList();

    var kernings = kerningsXml.findElements("kerning").map((kerningXml) {
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