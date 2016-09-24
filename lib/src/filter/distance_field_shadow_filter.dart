part of stagexl_bitmapfont;

class DistanceFieldShadowFilter extends BitmapFilter {

  /// This configuration of the inner distance field
  DistanceFieldConfig innerConfig;

  /// This configuration of the shadow distance field
  DistanceFieldConfig shadowConfig;

  /// The horizontal offset of the shadow.
  num offsetX;

  /// The vertical offset of the shadow.
  num offsetY;

  //---------------------------------------------------------------------------

  DistanceFieldShadowFilter(
      this.innerConfig, this.shadowConfig, this.offsetX, this.offsetY);

  BitmapFilter clone() {
    var innerConfig = this.innerConfig.clone();
    var shadowConfig = this.shadowConfig.clone();
    return new DistanceFieldShadowFilter(
        innerConfig, shadowConfig, this.offsetX, this.offsetY);
  }

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

    renderState.globalMatrix.prependTranslation(offsetX, offsetY);
    renderProgram.renderDistanceFieldFilterQuad(
        renderState, renderTextureQuad, this.shadowConfig);

    renderState.globalMatrix.prependTranslation(-offsetX, -offsetY);
    renderProgram.renderDistanceFieldFilterQuad(
        renderState, renderTextureQuad, this.innerConfig);
  }
}
