
float ui_dot_size;

void ui_setup() {
  // Calc dot size
  ui_dot_size = min(
    (width - (border * 2.0)) / config_canvasW,
    (height - (border * 2.0)) / config_canvasH
  );
  
}

void ui_render() {
  fill(255);
  textSize(24);
  textLeading(26);
  text("FlipDot\ncontroller", 940, 60);
  
  ui_simulate();
  
  image(virtualDisplay, 900, 400, virtualDisplay.width * 3, virtualDisplay.height * 3);
  
  
  // Network adapters
  textSize(13);
  fill(255);
  text("Network adapters:", 900, 500);
  for (int i = 0; i < adapters.length; i++) {
    fill(255);
    text(adapters[i], 915, 520 + i * 20);

    fill(212, 15, 15);
    try {
      if (clients[i].ip() != null) {
        fill(18, 222, 45);
      }
    } catch(NullPointerException e) {}
    
    ellipse(906, 515 + i * 20, 7, 7);
    fill(0);
  }
}

void ui_simulate() {
  translate(border, border);
  ellipseMode(CORNER);
  for (int i = 0; i < panels.length; i++) {
    push();
    translate(panels[i].x * ui_dot_size, panels[i].y * ui_dot_size);
    
    fill(0);
    stroke(255, 0, 0);
    strokeWeight(1);
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
}
