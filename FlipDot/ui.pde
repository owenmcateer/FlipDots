/**
 * UI
 *
 * Useful for debugging and FlipDot simulator.
 */
float ui_dot_size;
void ui_setup() {
  // Calc dot size
  float min_ui_space = 300;
  ui_dot_size = min(
    (width - (border * 2.0) - min_ui_space) / config_canvasW,
    (height - (border * 2.0)) / config_canvasH
  ); 
}


/**
 * Render UI to Processing window
 */
void ui_render() {
  float ui_offset = ui_dot_size * config_canvasW + (border * 2);
  
  stroke(255);
  line(ui_offset - border / 2, border, ui_offset - border / 2, height - border);
  line(ui_offset, 100, width - border, 100);

  fill(255);
  textSize(24);
  textLeading(26);
  noStroke();
  text("FlipDot controller", ui_offset, 60);
  textSize(15);
  text("https://github.com/owenmcateer/FlipDots", ui_offset, 85);
  
  // App stats
  text(config_cast ? "Casting" : "Not casting", ui_offset, 120);
  text(round(frameRate) + " fps (target: " + config_fps + "fps)", ui_offset, 140);
  text("Runtime: " + secondsToTime(round(frameCount / config_fps)), ui_offset, 160);
  
  // Simulator
  if (config_show_simulator) {
    ui_simulate();
  }
  
  // Virtual canvas
  float maxSize = width - ui_offset - border;
  float vcScaleWidth = maxSize / virtualDisplay.width;
  float vcScaleHeight = maxSize / virtualDisplay.height;
  float vcScale = min(vcScaleWidth, vcScaleHeight);
  stroke(255);
  strokeWeight(2);
  rect(ui_offset, 180, virtualDisplay.width * vcScale, virtualDisplay.height * vcScale);
  image(virtualDisplay, ui_offset, 180, virtualDisplay.width * vcScale, virtualDisplay.height * vcScale);
  
  // Casting mode
  textSize(15);
  fill(255);
  noStroke();
  push();
  translate(ui_offset, 220 + virtualDisplay.height * vcScale);
  // Network adapters
  if (castOver == 1) {
    text("Casting mode: ETH:", 0, 0);
    for (int i = 0; i < netAdapters.length; i++) {
      fill(255);
      text(netAdapters[i], 15, 20 + i * 20);
  
      fill(212, 15, 15);
      try {
        if (adaptersNet[i].ip() != null) {
          fill(18, 222, 45);
        }
      } catch(NullPointerException e) {}
      
      ellipse(6, 15 + i * 20, 7, 7);
      fill(0);
    }
  }
  else if (castOver == 2) {
    text("Casting mode: USB:", 0, 0);
    for (int i = 0; i < serialAdapters.length; i++) {
      fill(255);
      text(serialAdapters[i], 15, 20 + i * 20);
 
      fill(18, 222, 45);
      ellipse(6, 15 + i * 20, 7, 7);
      fill(0);
    }
  }
  pop();
}


/**
 * Processing virtual canvas to simulation display
 */
void ui_simulate() {
  push();
  translate(border, border);
  ellipseMode(CORNER);
  for (int i = 0; i < panels.length; i++) {
    push();
    translate(panels[i].x * ui_dot_size, panels[i].y * ui_dot_size);
    
    fill(0);
    noStroke();
    rect(0, 0, 28 * ui_dot_size, 7 * ui_dot_size);
    
    for (int col = 0; col < 28; col++) {
      for (int row = 0; row < 7; row++) {
        noStroke();
        fill(boolean(panels[i].buffer[col] & 1 << row) ? 255 : 0);
        circle(col * ui_dot_size, row * ui_dot_size, ui_dot_size - 2);
      }
    }
    
    pop();
  }
  pop();
}


/**
 * Seconds to time string
 *
 * @param {int} seconds | Second elapsed
 * @return {String}     | Date stamp HH:MM:SS
 */
String secondsToTime(int seconds) {
  int hours = seconds / 3600;
  int minutes = (seconds % 3600) / 60;
  int secs = seconds % 60;
  return String.format("%02d:%02d:%02d", hours, minutes, secs);
}
