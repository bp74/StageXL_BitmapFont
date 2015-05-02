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
  StageXL.bitmapDataLoadOptions.webp = true;

  // Init Stage and RenderLoop

  var stage = new Stage(html.querySelector('#stage'), width: 800, height: 400);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load BitmapFont

  var fontUrl = "../common/fonts/fnt/Luckiest_Guy.fnt";
  //var fontUrl = "../common/fonts/fnt/Fascinate_Inline.fnt";
  //var fontUrl = "../common/fonts/fnt/Orbitron.fnt";
  //var fontUrl = "../common/fonts/fnt/Permanent_Marker.fnt";
  //var fontUrl = "../common/fonts/fnt/Sarina.fnt";
  //var fontUrl = "../common/fonts/fnt/Sigmar_One.fnt";

  var bitmapFont = await BitmapFont.load(fontUrl, BitmapFontFormat.FNT);

  // create BitmapText and add it to the Stage

  var bitmapText = new BitmapText(bitmapFont);
  bitmapText.x = 50;
  bitmapText.y = 50;
  bitmapText.text = text;
  bitmapText.addTo(stage);

  animateBitmapText(bitmapText, stage.juggler);
}

//-----------------------------------------------------------------------------

void animateBitmapText(BitmapText bitmapText, Juggler juggler) {

  for (var bitmap in bitmapText.children) {
    bitmap.pivotX = bitmap.width / 2;
    bitmap.pivotY = bitmap.height / 2;
    bitmap.x += bitmap.pivotX;
    bitmap.y += bitmap.pivotY;
  }

  juggler.transition(0, 30000, 3600, TransitionFunction.linear, (value) {
    for (var bitmap in bitmapText.children) {
      bitmap.rotation = 0.2 * math.sin(value + bitmap.x);
    }
  });
}

