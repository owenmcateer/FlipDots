/**
 * FlipDot Controller
 *
 * This Processing sketch is to control FlipDot panels from AlfaZeta.
 * It uses a virtual display you can draw and animate on that then gets cast to your FlipDot display panels.
 *
 * If you don't have a FlipDot display you can still use this software as a FlipDot simulator. Just set `config_cast = false`
 *
 * @author Owen McAteer
 * @url https://github.com/owenmcateer/FlipDots
 * @socials https://x.com/motus_art
 * @socials https://instagram.com/motus_art
 *
 * Required libraries
 * - processing.net | Processing foundation
 * - processing.serial | Processing foundation
 * - websockets | Lasse Steenbock Vestergaard | (Only for realtime Crypo feed example)
 */
ClusterGrowth cluster_growth;

void setup() {
  size(1080, 720, P2D);
  frameRate(config_fps);
  colorMode(RGB, 255, 255, 255, 1);

  // Core setup functions
  cast_setup();
  config_setup();
  stages_setup();
  ui_setup();

  // Scene setup
  cluster_growth = new ClusterGrowth();
}


/**
 * Draw tick
 */
void draw() {
  background(59);

  // 3D test
  virtual3D.beginDraw();
  virtual3D.background(0);
  virtual3D.translate(virtual3D.width / 2, virtual3D.height / 2);
  virtual3D.rotateX(frameCount / 20.0);
  virtual3D.rotateY(frameCount / 20.0);
  virtual3D.stroke(255);
  virtual3D.strokeWeight(2);
  virtual3D.noFill();
  virtual3D.box(14);
  virtual3D.endDraw();
  // End 3D test

  // Between beginDraw/endDraw you can draw whatever you want to virtualDisplay(PGraphics)
  virtualDisplay.beginDraw();
  virtualDisplay.background(0);

  // Examples
  //example_blips(); // Blips animation
  example_anim(); // Animations
  //cluster_growth.draw(); // Cluster growth
  
  // Games
  //games_tetris();

  // End drawing
  virtualDisplay.endDraw();

  // Preview frame render
  ui_render();

  // Process frame
  stage_process();

  // Cast to display
  cast_broadcast();
}
