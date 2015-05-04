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
takimata sanctus est Lorem ipsum dolor
sit amet.""";

Future main() async {

  // Configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.LightCyan;
  StageXL.bitmapDataLoadOptions.webp = true;

  // Init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 1600, height: 700);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load BitmapFont

  var fontUrl = "../common/fonts/fnt/Fascinate_Inline.fnt";
  var bitmapFont = await BitmapFont.load(fontUrl, BitmapFontFormat.FNT);

  // create BitmapText and add it to the Stage

  var bitmapText = new BitmapText(bitmapFont);
  bitmapText.x = 50;
  bitmapText.y = 50;
  bitmapText.text = text;
  bitmapText.addTo(stage);

  // add an individual TintFilter to each character

  tintBitmapText(bitmapText);
  animateBitmapText(bitmapText, stage.juggler);
}

//-----------------------------------------------------------------------------

void tintBitmapText(BitmapText bitmapText) {

  var random = new math.Random();

  for (var bitmap in bitmapText.children) {
    var color = 0xFF000000 + random.nextInt(0xFFFFFF);
    var filter = new TintFilter.fromColor(color);
    bitmap.filters = [filter];
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

  await for (var elapsedTime in juggler.onElapsedTimeChange) {
    for (var bitmap in bitmapText.children) {
      bitmap.rotation = 0.2 * math.sin(elapsedTime * 8 + bitmap.x);
    }
  }
}
