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
  StageXL.stageOptions.stageScaleMode = StageScaleMode.NO_SCALE;

  //  StageXL.bitmapDataLoadOptions.pixelRatios = <double>[1.0, 2.0, 3.0];

  StageXL.bitmapDataLoadOptions.pixelRatios = <double>[3.0];

  // Init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 400);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load BitmapFont

  var fontUrl = "font/font@1x.fnt";
  var bitmapFont = await BitmapFont.load(fontUrl);

  // create BitmapText and add it to the Stage

  var bitmapText = new BitmapText(bitmapFont);
  bitmapText.x = 50;
  bitmapText.y = 50;
  bitmapText.text = text;
  bitmapText.addTo(stage);

}

