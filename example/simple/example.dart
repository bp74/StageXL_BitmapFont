import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_bitmapfont/stagexl_bitmapfont.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager = new ResourceManager();

Future main() async {

  var canvas = html.querySelector('#stage');

  stage = new Stage(canvas, webGL: true, width:400, height: 500, color: Color.DarkSlateGray);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var fontUrl = "../common/fonts/xml/Luckiest_Guy.xml";
  var bitmapFontFormat = BitmapFontFormat.XML;
  var bitmapFont = await BitmapFont.load(fontUrl, bitmapFontFormat);


}
