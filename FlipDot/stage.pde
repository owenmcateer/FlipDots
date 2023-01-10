PGraphics virtualDisplay;
PGraphics virtual3D;

void stages_setup() {
  // Create virtual stages
  virtualDisplay = createGraphics(
    config_canvasW,
    config_canvasH,
    P2D
  );
  
  virtual3D = createGraphics(virtualDisplay.width, virtualDisplay.height, P3D);
}


/**
 * Process image.
 */
void stage_process() {
  virtualDisplay.filter(THRESHOLD, 0.5);
  virtualDisplay.loadPixels();
  
  for (int i = 0; i < panels.length; i++) {
    panels[i].process();
  }
}
