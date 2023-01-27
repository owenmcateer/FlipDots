/**
 * Example animations
 */
int scene = 0;
void example_anim() {
  // Styles
  virtualDisplay.background(0);
  virtualDisplay.stroke(255);
  virtualDisplay.noFill();

  /**
   * 3D cube
   */
  if (scene == 0) {
    virtualDisplay.image(virtual3D, 0, 0, virtual3D.width, virtual3D.height);
  }

  /**
   * Spinning lines
   */
  else if (scene == 1) {
    virtualDisplay.translate(virtualDisplay.width / 2, virtualDisplay.height / 2);
    for (int i = 0; i < 6; i++) {
      virtualDisplay.rotate(frameCount / 100.0);
      virtualDisplay.line(-virtualDisplay.width, 0, virtualDisplay.width, 0);
    }
  }

  /**
   * Square tunnel
   */
  else if (scene == 2) {
    virtualDisplay.stroke(255);
    virtualDisplay.strokeWeight(1);
    virtualDisplay.noFill();
    virtualDisplay.rectMode(CENTER);
    virtualDisplay.translate(virtualDisplay.width / 2, virtualDisplay.height / 2);
    for (int i = 0; i < 4; i++) {
      virtualDisplay.rotate(frameCount / 100.0);
      float s = map((i / 4.0 + frameCount/90.0)%1, 0, 1, 0, virtualDisplay.width);
      s = pow(1.2, s);
      virtualDisplay.rect(0, 0, s, s);
    }
  }

  /**
   * Clouds animation
   */
  else if (scene == 3) {
    virtualDisplay.background(0);
    float noiseScale = 0.03;
    float threshold = 0.5;
    float speedX = 0.004;
    float speedY = 0.005;
    float speedZ = 0.002;
    float noiseLevel = 2.0;

    virtualDisplay.loadPixels();
    for (int i = 0; i < virtualDisplay.pixels.length; i++) {
      float x = (i / 1) % virtualDisplay.width;
      float y = (i / 1) / virtualDisplay.width;
      float n = 0.0;
      for (int j = 0; j < noiseLevel; j += 1) {
        float level = pow(2, j);
        n += noise(
          (x * noiseScale + frameCount * speedX) * level,
          (y * noiseScale + frameCount * speedY) * level,
          frameCount * speedZ * level
        );
      }
      n /= noiseLevel;
      if (n > threshold) {
        virtualDisplay.pixels[i] = 255;
      }
      else {
        virtualDisplay.pixels[i] = 0;
      }
    }
    virtualDisplay.updatePixels();
  }


  // Update scene ever 10s
  if (frameCount % 300 == 0) {
    scene++;
    if (scene > 3) scene = 0;
  }
}
