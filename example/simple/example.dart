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

  var fontUrl = "../common/fonts/fnt/Luckiest_Guy.fnt";
  //var fontUrl = "../common/fonts/fnt/Fascinate_Inline.fnt";
  //var fontUrl = "../common/fonts/fnt/Orbitron.fnt";
  //var fontUrl = "../common/fonts/fnt/Permanent_Marker.fnt";
  //var fontUrl = "../common/fonts/fnt/Sarina.fnt";
  //var fontUrl = "../common/fonts/fnt/Sigmar_One.fnt";

  var bitmapFontFormat = BitmapFontFormat.FNT;
  var bitmapFont = await BitmapFont.load(fontUrl, bitmapFontFormat);
  var bitmapText = new BitmapText(bitmapFont);

  bitmapText.x = 50;
  bitmapText.y = 50;
  bitmapText.text = text;
  bitmapText.addTo(stage);

}
