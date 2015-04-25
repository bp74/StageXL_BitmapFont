import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;
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

  stage = new Stage(canvas, webGL: true, width: 800, height: 400, color: Color.DarkSlateGray);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var fontUrl = "../common/fonts/fnt/Fascinate_Inline.fnt";
  var bitmapFontFormat = BitmapFontFormat.FNT;
  var bitmapFont = await BitmapFont.load(fontUrl, bitmapFontFormat);
  var bitmapText = new BitmapText(bitmapFont);

  bitmapText.x = 50;
  bitmapText.y = 50;
  bitmapText.text = text;
  bitmapText.addTo(stage);

  tintBitmapText(bitmapText);
  animateBitmapText(bitmapText);
}

//-----------------------------------------------------------------------------

void tintBitmapText(BitmapText bitmapText) {
  var random = new math.Random();
  for(var bitmap in bitmapText.children) {
    var r = random.nextInt(100) + 155;
    var g = random.nextInt(100) + 155;
    var b = random.nextInt(100) + 155;
    var color = 0xFF000000 + (r << 16) + (g << 8) + (b << 0);
    var filter = new TintFilter.fromColor(color);
    bitmap.filters = [filter];
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


