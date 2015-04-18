part of stagexl_bitmapfont;

// http://www.angelcode.com/products/bmfont/doc/file_format.html

abstract class BitmapFontFormat {

  static const BitmapFontFormat FNT = const _BitmapFontFormatFnt();
  static const BitmapFontFormat XML = const _BitmapFontFormatXml();
  static const BitmapFontFormat JSON = const _BitmapFontFormatJson();

  const BitmapFontFormat();

  Future<BitmapFont> load(String url, BitmapDataLoadOptions bitmapDataLoadOptions);
}

//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

class _BitmapFontFormatFnt extends BitmapFontFormat {

  const _BitmapFontFormatFnt();

  Future<BitmapFont> load(String url, BitmapDataLoadOptions bitmapDataLoadOptions) async {

    throw new UnimplementedError("");

  }
}

//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

class _BitmapFontFormatXml extends BitmapFontFormat {

  const _BitmapFontFormatXml();

  Future<BitmapFont> load(String url, BitmapDataLoadOptions bitmapDataLoadOptions) async {

    if (bitmapDataLoadOptions == null) {
      bitmapDataLoadOptions = BitmapData.defaultLoadOptions;
    }

    var xmlText = await HttpRequest.getString(url);
    var xml = parse(xmlText);


    throw new UnimplementedError("");

  }
}

//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------

class _BitmapFontFormatJson extends BitmapFontFormat {

  const _BitmapFontFormatJson();

  Future<BitmapFont> load(String url, BitmapDataLoadOptions bitmapDataLoadOptions) async {

    throw new UnimplementedError("");

  }
}

