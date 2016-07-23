import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_bitmapfont/stagexl_bitmapfont.dart';

String text = """
Hello World!
Grumpy wizards make 
toxic brew for the 
evil Queen and Jack.""";

Future main() async {

  // Configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.DarkSlateGray;

  // Init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 1000, height: 400);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load BitmapFont

  var fontUrl = "assets/font.fnt";
  var bitmapFont = await BitmapFont.load(fontUrl, BitmapFontFormat.FNT);

  // create BitmapText and add it to the Stage

  var bitmapText = new BitmapText(bitmapFont);
  bitmapText.x = 500;
  bitmapText.y = 180;
  bitmapText.text = text;
  bitmapText.alignPivot();
  bitmapText.addTo(stage);

  // add the DistanceFieldFilter for sharp edges

  var filter = new DistanceFieldFilter(Color.White);
  bitmapText.filters = [filter];

  // animate BitmapText

  await for (var elapsedTime in stage.juggler.onElapsedTimeChange) {
    var scale = 1.75 + 1.5 * math.sin(elapsedTime * 0.5);
    bitmapText.scaleX = bitmapText.scaleY = scale;
  }

}


