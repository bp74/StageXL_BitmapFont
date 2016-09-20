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

  var config1 = new DistanceFieldConfig(0.50, 0.25, Color.White);
  var filter1 = new DistanceFieldFilter(config1);

  var config2 = new DistanceFieldConfig(0.70, 0.20, Color.White);
  var config3 = new DistanceFieldConfig(0.30, 0.20, Color.Black);
  var filter2 = new DistanceFieldOutlineFilter(config2, config3);

  var config4 = new DistanceFieldConfig(0.70, 0.20, Color.White);
  var config5 = new DistanceFieldConfig(0.30, 0.20, 0x80FF0000);
  var filter3 = new DistanceFieldGlowFilter(config4, config5);

  var filters = [filter1, filter2, filter3];
  var filterIndex = 0;

  bitmapText.filters.clear();
  bitmapText.filters.add(filters[0]);

  stage.onMouseClick.listen((mouseEvent) {
    filterIndex = (filterIndex + 1) % filters.length;
    bitmapText.filters.clear();
    bitmapText.filters.add(filters[filterIndex]);
  });

  // animate BitmapText

  await for (var elapsedTime in stage.juggler.onElapsedTimeChange) {
    var scale = 2.0 + 1.5 * math.sin(elapsedTime * 0.5);
    bitmapText.scaleX = bitmapText.scaleY = scale;
  }

}


