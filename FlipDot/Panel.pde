
class Panel {
  int adapter;
  int id;
  String aps;
  int x;
  int y;
  byte[] buffer = new byte[28];
    
  Panel(int adapterId, int panelNum, int offsetX, int offsetY) {
    adapter = adapterId;
    id = panelNum;
    x = offsetX;
    y = offsetY;
    for (int i = 0; i < 28; i++) {
      buffer[i] = byte(0);
    }
  }
  
  void process() {
    int offset = y * config_canvasW + x;
    
    // Loop columns in panel
    for (int col = 0; col < 28; col++) {
      byte b = (byte)0x00;
      int index = offset + col;
      
      for (int panel_row = 0; panel_row < 7; panel_row++) {
        int pixelLocationY = index + (panel_row * config_canvasW);
        if (brightness(virtualDisplay.pixels[pixelLocationY]) > 0.5) {
          b |= 1 << panel_row;
        }
      }
      buffer[col] = b;
    }
  }
  
}
