part of stagexl_bitmapfont;

class DistanceFieldFilter extends BitmapFilter {

  int color;
  num threshold;
  num softness;

  DistanceFieldFilter([
      this.color = Color.White,
      this.threshold = 0.50,
      this.softness = 0.25
  ]);

  BitmapFilter clone() => new DistanceFieldFilter(this.color);

  //---------------------------------------------------------------------------

  void apply(BitmapData bitmapData, [Rectangle<num> rectangle]) {
    // TODO: implement DistanceFieldFilter for BitmapDatas.
  }

  //---------------------------------------------------------------------------

  void renderFilter(
      RenderState renderState, RenderTextureQuad renderTextureQuad, int pass) {

    RenderContextWebGL renderContext = renderState.renderContext;
    RenderTexture renderTexture = renderTextureQuad.renderTexture;

    DistanceFieldFilterProgram renderProgram = renderContext.getRenderProgram(
        r"$DistanceFieldFilterProgram", () => new DistanceFieldFilterProgram());

    renderContext.activateRenderProgram(renderProgram);
    renderContext.activateRenderTexture(renderTexture);
    renderProgram.renderDistanceFieldFilterQuad(
        renderState, renderTextureQuad, this);
  }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

class DistanceFieldFilterProgram extends RenderProgram {

  // aPosition:    Float32(x), Float32(y)
  // aTexCoord:    Float32(u), Float32(v)
  // aColor:       Float32(r), Float32(g), Float32(b), Float32(a)
  // aSetup:       Float32(threshold), Float32(gamma)

  @override
  String get vertexShaderSource => """

    uniform mat4 uProjectionMatrix;

    attribute vec2 aPosition;
    attribute vec2 aTexCoord;
    attribute vec4 aColor;
    attribute vec2 aSetup;

    varying vec2 vTexCoord;
    varying vec4 vColor;
    varying vec2 vSetup;
    varying vec2 vBounds;

    void main() {
      vTexCoord = aTexCoord;
      vColor = aColor;
      vSetup = aSetup;
      vBounds = vec2(aSetup.x - aSetup.y, aSetup.x + aSetup.y);
      gl_Position = vec4(aPosition, 0.0, 1.0) * uProjectionMatrix;
    }
    """;

  @override
  String get fragmentShaderSource => """

    precision mediump float;
    uniform sampler2D uSampler;

    varying vec2 vTexCoord;
    varying vec4 vColor;
    varying vec2 vSetup;
    varying vec2 vBounds;

    void main() {
      float dist = texture2D(uSampler, vTexCoord).a;
      float alpha = smoothstep(vBounds.x, vBounds.y, dist);
      gl_FragColor = vColor * alpha;
    }
    """;

  //---------------------------------------------------------------------------

  @override
  void activate(RenderContextWebGL renderContext) {

    super.activate(renderContext);

    renderingContext.uniform1i(uniforms["uSampler"], 0);

    renderBufferVertex.bindAttribute(attributes["aPosition"], 2, 40, 0);
    renderBufferVertex.bindAttribute(attributes["aTexCoord"], 2, 40, 8);
    renderBufferVertex.bindAttribute(attributes["aColor"],    4, 40, 16);
    renderBufferVertex.bindAttribute(attributes["aSetup"],    2, 40, 32);
  }

  //---------------------------------------------------------------------------

  void renderDistanceFieldFilterQuad(
      RenderState renderState,
      RenderTextureQuad renderTextureQuad,
      DistanceFieldFilter distanceFieldFilter) {

    var alpha = renderState.globalAlpha;
    var matrix = renderState.globalMatrix;
    var ixList = renderTextureQuad.ixList;
    var vxList = renderTextureQuad.vxList;
    var indexCount = ixList.length;
    var vertexCount = vxList.length >> 2;

    // setup

    int color = distanceFieldFilter.color;
    num colorA = ((color >> 24) & 0xFF) / 255.0 * alpha;
    num colorR = ((color >> 16) & 0xFF) / 255.0;
    num colorG = ((color >>  8) & 0xFF) / 255.0;
    num colorB = ((color >>  0) & 0xFF) / 255.0;

    var threshold = distanceFieldFilter.threshold;
    var softness = distanceFieldFilter.softness;
    var scale = math.sqrt(matrix.det);

    var gamma = softness / scale;
    if (gamma > 0.50) gamma = 0.50;

    // check buffer sizes and flush if necessary

    var ixData = renderBufferIndex.data;
    var ixPosition = renderBufferIndex.position;
    if (ixPosition + indexCount >= ixData.length) flush();

    var vxData = renderBufferVertex.data;
    var vxPosition = renderBufferVertex.position;
    if (vxPosition + vertexCount * 10 >= vxData.length) flush();

    var ixIndex = renderBufferIndex.position;
    var vxIndex = renderBufferVertex.position;
    var vxCount = renderBufferVertex.count;

    // copy index list

    for(var i = 0; i < indexCount; i++) {
      ixData[ixIndex + i] = vxCount + ixList[i];
    }

    renderBufferIndex.position += indexCount;
    renderBufferIndex.count += indexCount;

    // copy vertex list

    var ma = matrix.a;
    var mb = matrix.b;
    var mc = matrix.c;
    var md = matrix.d;
    var mx = matrix.tx;
    var my = matrix.ty;

    for(var i = 0, o = 0; i < vertexCount; i++, o += 4) {
      num x = vxList[o + 0];
      num y = vxList[o + 1];
      vxData[vxIndex + 00] = mx + ma * x + mc * y;
      vxData[vxIndex + 01] = my + mb * x + md * y;
      vxData[vxIndex + 02] = vxList[o + 2];
      vxData[vxIndex + 03] = vxList[o + 3];
      vxData[vxIndex + 04] = colorR;
      vxData[vxIndex + 05] = colorG;
      vxData[vxIndex + 06] = colorB;
      vxData[vxIndex + 07] = colorA;
      vxData[vxIndex + 08] = threshold;
      vxData[vxIndex + 09] = gamma;
      vxIndex += 10;
    }

    renderBufferVertex.position += vertexCount * 10;
    renderBufferVertex.count += vertexCount;
  }

}
