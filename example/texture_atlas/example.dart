import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_bitmapfont/stagexl_bitmapfont.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager = new ResourceManager();

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

  StageXL.bitmapDataLoadOptions.webp = true;

  var canvas = html.querySelector('#stage');
  stage = new Stage(canvas, webGL: true, width: 1600, height: 800, color: Color.DarkSlateGray);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  resourceManager = new ResourceManager();
  resourceManager.addTextureAtlas("atlas", "../common/images/font_atlas.json");
  resourceManager.addTextFile("font1", "../common/fonts/fnt/Luckiest_Guy.fnt");
  resourceManager.addTextFile("font2", "../common/fonts/fnt/Fascinate_Inline.fnt");
  resourceManager.addTextFile("font3", "../common/fonts/fnt/Sarina.fnt");
  resourceManager.addTextFile("font4", "../common/fonts/fnt/Sigmar_One.fnt");
  await resourceManager.load();

  var definition1 = resourceManager.getTextFile("font1");
  var definition2 = resourceManager.getTextFile("font2");
  var definition3 = resourceManager.getTextFile("font3");
  var definition4 = resourceManager.getTextFile("font4");

  var format = BitmapFontFormat.FNT;
  var atlas = resourceManager.getTextureAtlas("atlas");
  var font1 = await BitmapFont.fromTextureAtlas(definition1, atlas, format);
  var font2 = await BitmapFont.fromTextureAtlas(definition2, atlas, format);
  var font3 = await BitmapFont.fromTextureAtlas(definition3, atlas, format);
  var font4 = await BitmapFont.fromTextureAtlas(definition4, atlas, format);

  var fonts = [font1, font2, font3, font4];
  var lines = text.split(new RegExp(r"\r\n|\r|\n"));

  for(int i = 0; i < lines.length; i++) {
    var font = fonts[i % fonts.length];
    var bitmapText = new BitmapText(font);
    bitmapText.x = 50;
    bitmapText.y = 50 + i * 64;
    bitmapText.text = lines[i];
    bitmapText.addTo(stage);
    animateBitmapText(bitmapText);
  }
}

//-----------------------------------------------------------------------------

void animateBitmapText(BitmapText bitmapText) {

  for(var bitmap in bitmapText.children) {
    bitmap.pivotX = bitmap.width / 2;
    bitmap.pivotY = bitmap.height / 2;
    bitmap.x += bitmap.pivotX;
    bitmap.y += bitmap.pivotY;
  }

  var transtionFunction = TransitionFunction.linear;
  var transition = new Transition(0, 10000, 1200, transtionFunction);
  stage.juggler.add(transition);

  transition.onUpdate = (value) {
    for(var bitmap in bitmapText.children) {
      bitmap.rotation = 0.2 * math.sin(value + bitmap.x);
    }
  };
}




