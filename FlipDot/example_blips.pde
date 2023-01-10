/**
 * Example: Blips
 *
 * Random growing blips.
 */
void example_blips() {
  // Styles
  virtualDisplay.background(0);
  virtualDisplay.stroke(255);
  virtualDisplay.noFill();
  
  // Blips config
  int blips_count = 5;
  float blips_max_speed = 150.0;
  float blips_weight = 40.0;
  
  // Draw blips
  for (int i = 0; i < blips_count; i++) {
    float phaseShift = noise(i) * blips_max_speed;
    float phase = (frameCount % phaseShift) / phaseShift;
    float flatPhase = floor(frameCount / phaseShift);
  
    virtualDisplay.strokeWeight(phaseShift / blips_weight);
    virtualDisplay.ellipse(
      noise(i, 1, flatPhase) * virtualDisplay.width,
      noise(i, 2, flatPhase) * virtualDisplay.height,
      phase * (virtualDisplay.width * 2),
      phase * (virtualDisplay.width * 2)
    );
  }
}
