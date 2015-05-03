import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_bitmapfont/stagexl_bitmapfont.dart';

String text = """
Lorem ipsum dolor sit amet, consetetur 
sadipscing elitr, sed diam nonumy eirmod 
tempor invidunt ut labore et dolore magna 
aliquyam erat, sed diam voluptua. At vero 
eos et accusam et justo duo dolores et ea 
rebum. Stet clita kasd gubergren, no sea 
takimata sanctus est Lorem ipsum dolor sit 
amet. Lorem ipsum dolor sit amet, consetetur 
sadipscing elitr, sed diam nonumy eirmod 
tempor invidunt ut labore et dolore magna 
aliquyam erat, sed diam voluptua.""";

Future main() async {

  // Configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.DarkSlateGray;
  StageXL.bitmapDataLoadOptions.webp = true;

  // Init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 1600, height: 800);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load TextureAtlas with glyphs and font files for later use

  var resourceManager = new ResourceManager();
  resourceManager.addTextureAtlas("atlas", "../common/images/font_atlas.json");
  resourceManager.addTextFile("fnt1", "../common/fonts/fnt/Luckiest_Guy.fnt");
  resourceManager.addTextFile("fnt2", "../common/fonts/fnt/Fascinate_Inline.fnt");
  resourceManager.addTextFile("fnt3", "../common/fonts/fnt/Sarina.fnt");
  resourceManager.addTextFile("fnt4", "../common/fonts/fnt/Sigmar_One.fnt");
  await resourceManager.load();

  // Create BitmapFonts with resources from the ResourceManager

  var atlas = resourceManager.getTextureAtlas("atlas");
  var source1 = resourceManager.getTextFile("fnt1");
  var source2 = resourceManager.getTextFile("fnt2");
  var source3 = resourceManager.getTextFile("fnt3");
  var source4 = resourceManager.getTextFile("fnt4");

  var fonts = await Future.wait([
    BitmapFont.fromTextureAtlas(atlas, "", source1, BitmapFontFormat.FNT),
    BitmapFont.fromTextureAtlas(atlas, "", source2, BitmapFontFormat.FNT),
    BitmapFont.fromTextureAtlas(atlas, "", source3, BitmapFontFormat.FNT),
    BitmapFont.fromTextureAtlas(atlas, "", source4, BitmapFontFormat.FNT)
  ]);

  // Create a BitmapText for each line and use a different font

  var lines = text.split(new RegExp(r"\r\n|\r|\n"));

  for (int i = 0; i < lines.length; i++) {
    var font = fonts[i % fonts.length];
    var bitmapText = new BitmapText(font);
    bitmapText.x = 50;
    bitmapText.y = 50 + i * 64;
    bitmapText.text = lines[i];
    bitmapText.addTo(stage);
    animateBitmapText(bitmapText, stage.juggler);
  }
}

//-----------------------------------------------------------------------------

Future animateBitmapText(BitmapText bitmapText, Juggler juggler) async {

  for (var bitmap in bitmapText.children) {
    bitmap.pivotX = bitmap.width / 2;
    bitmap.pivotY = bitmap.height / 2;
    bitmap.x += bitmap.pivotX;
    bitmap.y += bitmap.pivotY;
  }

  await for (var elapsedTime in juggler.onElapsedTimeChanged) {
    for (var bitmap in bitmapText.children) {
      bitmap.rotation = 0.2 * math.sin(elapsedTime * 8 + bitmap.x);
    }
  }
}
