part of stagexl_bitmapfont;

class DistanceFieldOutlineFilter extends BitmapFilter {

  /// The color inside of the edges.
  int innerColor;

  /// The color of the outline.
  int outlineColor;

  /// This configuration of the distance field;
  DistanceFieldConfig config;

  //---------------------------------------------------------------------------

  DistanceFieldOutlineFilter({
    this.innerColor: Color.White,
    this.outlineColor: Color.Black,
    this.config}) {
    this.config ??= new DistanceFieldConfig();
  }

  BitmapFilter clone() => new DistanceFieldOutlineFilter(
      innerColor: this.innerColor,
      outlineColor: this.outlineColor,
      config: this.config.clone());

  //---------------------------------------------------------------------------

  void apply(BitmapData bitmapData, [Rectangle<num> rectangle]) {
    // TODO: implement DistanceFieldOutlineFilter for BitmapDatas.
  }

  //---------------------------------------------------------------------------

  void renderFilter(
      RenderState renderState, RenderTextureQuad renderTextureQuad, int pass) {

    RenderContextWebGL renderContext = renderState.renderContext;
    RenderTexture renderTexture = renderTextureQuad.renderTexture;
    DistanceFieldOutlineFilterProgram renderProgram;

    renderProgram = renderContext.getRenderProgram(
        r"$DistanceFieldOutlineFilterProgram",
        () => new DistanceFieldOutlineFilterProgram());

    renderContext.activateRenderProgram(renderProgram);
    renderContext.activateRenderTexture(renderTexture);
    renderProgram.renderDistanceFieldOutlineFilterQuad(
        renderState, renderTextureQuad, this);
  }
}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

class DistanceFieldOutlineFilterProgram extends RenderProgram {

  // aPosition:   Float32(x), Float32(y)
  // aTexCoord:   Float32(u), Float32(v)
  // aInnerColor: Float32(r), Float32(g), Float32(b), Float32(a)
  // aOuterColor: Float32(r), Float32(g), Float32(b), Float32(a)
  // aSetup:      Float32(innerThresholdMin), Float32(innerThresholdMax),
  //              Float32(outerThresholdMin), Float32(outerThresholdMax),

  @override
  String get vertexShaderSource => """

    uniform mat4 uProjectionMatrix;

    attribute vec2 aPosition;
    attribute vec2 aTexCoord;
    attribute vec4 aInnerColor;
    attribute vec4 aOuterColor;
    attribute vec4 aThreshold;

    varying vec2 vTexCoord;
    varying vec4 vInnerColor;
    varying vec4 vOuterColor;
    varying vec4 vThreshold;

    void main() {
      vTexCoord = aTexCoord;
      vThreshold = aThreshold;
      vInnerColor = vec4(aInnerColor.rgb * aInnerColor.a, aInnerColor.a);
      vOuterColor = vec4(aOuterColor.rgb * aOuterColor.a, aOuterColor.a);
      gl_Position = vec4(aPosition, 0.0, 1.0) * uProjectionMatrix;
    }
    """;

  @override
  String get fragmentShaderSource => """

    precision mediump float;
    uniform sampler2D uSampler;

    varying vec2 vTexCoord;
    varying vec4 vInnerColor;
    varying vec4 vOuterColor;
    varying vec4 vThreshold;

    void main() {
      float dist = texture2D(uSampler, vTexCoord).a;
      float innerAlpha = smoothstep(vThreshold.x, vThreshold.y, dist);
      float outerAlpha = smoothstep(vThreshold.z, vThreshold.w, dist);
      outerAlpha = max(outerAlpha - innerAlpha, 0.0);
      gl_FragColor = vInnerColor * innerAlpha + vOuterColor * outerAlpha;
    }
    """;

  //---------------------------------------------------------------------------

  @override
  void activate(RenderContextWebGL renderContext) {

    super.activate(renderContext);

    renderingContext.uniform1i(uniforms["uSampler"], 0);

    renderBufferVertex.bindAttribute(attributes["aPosition"],   2, 64, 0);
    renderBufferVertex.bindAttribute(attributes["aTexCoord"],   2, 64, 8);
    renderBufferVertex.bindAttribute(attributes["aInnerColor"], 4, 64, 16);
    renderBufferVertex.bindAttribute(attributes["aOuterColor"], 4, 64, 32);
    renderBufferVertex.bindAttribute(attributes["aThreshold"],  4, 64, 48);
  }

  //---------------------------------------------------------------------------

  void renderDistanceFieldOutlineFilterQuad(
      RenderState renderState,
      RenderTextureQuad renderTextureQuad,
      DistanceFieldOutlineFilter distanceFieldOutlineFilter) {

    var alpha = renderState.globalAlpha;
    var matrix = renderState.globalMatrix;
    var ixList = renderTextureQuad.ixList;
    var vxList = renderTextureQuad.vxList;
    var indexCount = ixList.length;
    var vertexCount = vxList.length >> 2;

    // setup

    int innerColor = distanceFieldOutlineFilter.innerColor;
    num innerColorA = ((innerColor >> 24) & 0xFF) / 255.0 * alpha;
    num innerColorR = ((innerColor >> 16) & 0xFF) / 255.0;
    num innerColorG = ((innerColor >>  8) & 0xFF) / 255.0;
    num innerColorB = ((innerColor >>  0) & 0xFF) / 255.0;

    int outerColor = distanceFieldOutlineFilter.outlineColor;
    num outerColorA = ((outerColor >> 24) & 0xFF) / 255.0 * alpha;
    num outerColorR = ((outerColor >> 16) & 0xFF) / 255.0;
    num outerColorG = ((outerColor >>  8) & 0xFF) / 255.0;
    num outerColorB = ((outerColor >>  0) & 0xFF) / 255.0;

    num threshold = distanceFieldOutlineFilter.config.threshold;
    num softness = distanceFieldOutlineFilter.config.softness;
    num range = distanceFieldOutlineFilter.config.outline;
    num scale = math.sqrt(matrix.det);

    num gamma = softness / scale;
    num innerThresholdMin = threshold + range - gamma;
    num innerThresholdMax = threshold + range + gamma;
    num outerThresholdMin = threshold - range - gamma;
    num outerThresholdMax = threshold - range + gamma;

    if (innerThresholdMin < 0.0) innerThresholdMin = 0.0;
    if (innerThresholdMax > 1.0) innerThresholdMax = 1.0;
    if (outerThresholdMin < 0.0) outerThresholdMin = 0.0;
    if (outerThresholdMax > 1.0) outerThresholdMax = 1.0;

    // check buffer sizes and flush if necessary

    var ixData = renderBufferIndex.data;
    var ixPosition = renderBufferIndex.position;
    if (ixPosition + indexCount >= ixData.length) flush();

    var vxData = renderBufferVertex.data;
    var vxPosition = renderBufferVertex.position;
    if (vxPosition + vertexCount * 16 >= vxData.length) flush();

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
      vxData[vxIndex + 04] = innerColorR;
      vxData[vxIndex + 05] = innerColorG;
      vxData[vxIndex + 06] = innerColorB;
      vxData[vxIndex + 07] = innerColorA;
      vxData[vxIndex + 08] = outerColorR;
      vxData[vxIndex + 09] = outerColorG;
      vxData[vxIndex + 10] = outerColorB;
      vxData[vxIndex + 11] = outerColorA;
      vxData[vxIndex + 12] = innerThresholdMin;
      vxData[vxIndex + 13] = innerThresholdMax;
      vxData[vxIndex + 14] = outerThresholdMin;
      vxData[vxIndex + 15] = outerThresholdMax;
      vxIndex += 16;
    }

    renderBufferVertex.position += vertexCount * 16;
    renderBufferVertex.count += vertexCount;
  }

}
