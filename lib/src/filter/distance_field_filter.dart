part of stagexl_bitmapfont;

class DistanceFieldFilter extends BitmapFilter {

  /// The color inside of the edges.
  int innerColor;

  /// This configuration of the distance field;
  DistanceFieldConfig config;

  //---------------------------------------------------------------------------

  DistanceFieldFilter({
    this.innerColor: Color.White,
    this.config}) {
    this.config ??= new DistanceFieldConfig();
  }

  BitmapFilter clone() => new DistanceFieldFilter(
      innerColor: this.innerColor,
      config: this.config.clone());

  //---------------------------------------------------------------------------

  void apply(BitmapData bitmapData, [Rectangle<num> rectangle]) {
    // TODO: implement DistanceFieldFilter for BitmapDatas.
  }

  //---------------------------------------------------------------------------

  void renderFilter(
      RenderState renderState, RenderTextureQuad renderTextureQuad, int pass) {

    RenderContextWebGL renderContext = renderState.renderContext;
    RenderTexture renderTexture = renderTextureQuad.renderTexture;
    _DistanceFieldFilterProgram renderProgram;

    renderProgram  = renderContext.getRenderProgram(
        r"$DistanceFieldFilterProgram",
        () => new _DistanceFieldFilterProgram());

    renderContext.activateRenderProgram(renderProgram);
    renderContext.activateRenderTexture(renderTexture);
    renderProgram.renderDistanceFieldFilterQuad(
        renderState, renderTextureQuad, this);
  }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

class _DistanceFieldFilterProgram extends RenderProgram {

  // aPosition:   Float32(x), Float32(y)
  // aTexCoord:   Float32(u), Float32(v)
  // aInnerColor: Float32(r), Float32(g), Float32(b), Float32(a)
  // aThreshold:  Float32(thresholdMin), Float32(thresholdMax)

  @override
  String get vertexShaderSource => """

    uniform mat4 uProjectionMatrix;

    attribute vec2 aPosition;
    attribute vec2 aTexCoord;
    attribute vec4 aInnerColor;
    attribute vec2 aThreshold;

    varying vec2 vTexCoord;
    varying vec4 vInnerColor;
    varying vec2 vThreshold;

    void main() {
      vTexCoord = aTexCoord;
      vThreshold = aThreshold;
      vInnerColor = vec4(aInnerColor.rgb * aInnerColor.a, aInnerColor.a);
      gl_Position = vec4(aPosition, 0.0, 1.0) * uProjectionMatrix;
    }
    """;

  @override
  String get fragmentShaderSource => """

    precision mediump float;
    uniform sampler2D uSampler;

    varying vec2 vTexCoord;
    varying vec4 vInnerColor;
    varying vec2 vThreshold;

    void main() {
      float dist = texture2D(uSampler, vTexCoord).a;
      float alpha = smoothstep(vThreshold.x, vThreshold.y, dist);
      gl_FragColor = vInnerColor * alpha;
    }
    """;

  //---------------------------------------------------------------------------

  @override
  void activate(RenderContextWebGL renderContext) {

    super.activate(renderContext);

    renderingContext.uniform1i(uniforms["uSampler"], 0);

    renderBufferVertex.bindAttribute(attributes["aPosition"],   2, 40, 0);
    renderBufferVertex.bindAttribute(attributes["aTexCoord"],   2, 40, 8);
    renderBufferVertex.bindAttribute(attributes["aInnerColor"], 4, 40, 16);
    renderBufferVertex.bindAttribute(attributes["aThreshold"],  2, 40, 32);
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

    int color = distanceFieldFilter.innerColor;
    num colorA = ((color >> 24) & 0xFF) / 255.0 * alpha;
    num colorR = ((color >> 16) & 0xFF) / 255.0;
    num colorG = ((color >>  8) & 0xFF) / 255.0;
    num colorB = ((color >>  0) & 0xFF) / 255.0;

    num threshold = distanceFieldFilter.config.threshold;
    num softness = distanceFieldFilter.config.softness;
    num scale = math.sqrt(matrix.det);
    num gamma = softness / scale;
    num thresholdMin = threshold - gamma;
    num thresholdMax = threshold + gamma;

    if (thresholdMin < 0.0) thresholdMin = 0.0;
    if (thresholdMax > 1.0) thresholdMax = 1.0;

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
      vxData[vxIndex + 08] = thresholdMin;
      vxData[vxIndex + 09] = thresholdMax;
      vxIndex += 10;
    }

    renderBufferVertex.position += vertexCount * 10;
    renderBufferVertex.count += vertexCount;
  }

}
