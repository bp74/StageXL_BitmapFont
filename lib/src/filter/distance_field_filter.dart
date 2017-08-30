part of stagexl_bitmapfont;

class DistanceFieldFilter extends BitmapFilter {

  /// This configuration of the distance field;
  DistanceFieldConfig config;

  //---------------------------------------------------------------------------

  DistanceFieldFilter(this.config);

  @override
  BitmapFilter clone() {
    var config = this.config.clone();
    return new DistanceFieldFilter(config);
  }

  //---------------------------------------------------------------------------

  @override
  void apply(BitmapData bitmapData, [Rectangle<num> rectangle]) {
    // TODO: implement DistanceFieldFilter for BitmapDatas.
  }

  //---------------------------------------------------------------------------

  @override
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
        renderState, renderTextureQuad, this.config);
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
      float distance = texture2D(uSampler, vTexCoord).a;
      float alpha = smoothstep(vThreshold.x, vThreshold.y, distance);
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
      DistanceFieldConfig distanceFieldConfig) {

    var alpha = renderState.globalAlpha;
    var matrix = renderState.globalMatrix;
    var ixList = renderTextureQuad.ixList;
    var vxList = renderTextureQuad.vxList;
    var indexCount = ixList.length;
    var vertexCount = vxList.length >> 2;
    var scale = math.sqrt(matrix.det);

    // setup

    var config = distanceFieldConfig;
    var colorA = ((config.color >> 24) & 0xFF) / 255.0 * alpha;
    var colorR = ((config.color >> 16) & 0xFF) / 255.0;
    var colorG = ((config.color >>  8) & 0xFF) / 255.0;
    var colorB = ((config.color >>  0) & 0xFF) / 255.0;
    var thresholdMin = config.threshold - config.softness / scale;
    var thresholdMax = config.threshold + config.softness / scale;
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
