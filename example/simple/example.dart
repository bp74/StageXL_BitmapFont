import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_bitmapfont/stagexl_bitmapfont.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager = new ResourceManager();

String text = """
Hello World!
Grumpy wizards make 
toxic brew for the 
evil Queen and Jack.""";

Future main() async {

  StageXL.bitmapDataLoadOptions.webp = true;

  var canvas = html.querySelector('#stage');

  stage = new Stage(canvas, webGL: true, width: 800, height: 600, color: Color.DarkSlateGray);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var fontUrl = "../common/fonts/json/Luckiest_Guy.json";
  //var fontUrl = "../common/fonts/json/Fascinate_Inline.json";
  //var fontUrl = "../common/fonts/json/Orbitron.json";
  //var fontUrl = "../common/fonts/json/Permanent_Marker.json";
  //var fontUrl = "../common/fonts/json/Sarina.json";
  //var fontUrl = "../common/fonts/json/Sigmar_One.json";

  var bitmapFontFormat = BitmapFontFormat.JSON;
  var bitmapFont = await BitmapFont.load(fontUrl, bitmapFontFormat);
  var bitmapText = new BitmapText(bitmapFont);

  bitmapText.x = 50;
  bitmapText.y = 50;
  bitmapText.text = text;
  bitmapText.addTo(stage);

}
