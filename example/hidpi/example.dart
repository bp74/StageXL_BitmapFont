import 'dart:async';
import 'dart:html' as html;
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
  StageXL.bitmapDataLoadOptions.pixelRatios = <double>[1.0, 2.0, 3.0];
  //StageXL.bitmapDataLoadOptions.pixelRatios = <double>[1.0];

  // Init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = Stage(canvas, width: 800, height: 400);
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  // load BitmapFont from File (default)

  var bitmapFont = await BitmapFont.load("font/font@1x.fnt");

  // load BitmapFont from BitmapData (alternative)

  /*
  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("fontPng", "font/font@1x.png");
  resourceManager.addTextFile("font@1", "font/font@1x.fnt");
  resourceManager.addTextFile("font@2", "font/font@2x.fnt");
  resourceManager.addTextFile("font@3", "font/font@3x.fnt");
  await resourceManager.load();

  var fontBitmapData = resourceManager.getBitmapData("fontPng");
  var fontPixelRatio = fontBitmapData.renderTextureQuad.pixelRatio.toStringAsFixed(0);
  var fontDefinition = resourceManager.getTextFile("font@$fontPixelRatio");
  var bitmapFont = await BitmapFont.fromBitmapData(fontBitmapData, fontDefinition);
  */

  // create BitmapText and add it to the Stage

  var bitmapText = BitmapText(bitmapFont);
  bitmapText.x = 50;
  bitmapText.y = 50;
  bitmapText.text = text;
  bitmapText.addTo(stage);
}
