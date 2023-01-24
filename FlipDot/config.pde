// Config
boolean config_cast = false;
int config_fps = 30;
int config_canvasW = 28;
int config_canvasH = 14;
boolean config_video_sync = true;

// Network settings
// 1 = ETH network
// 2 = USB serial
int castOver = 1;

// Network device
// IP address:port
String[] netAdapters = {
  "192.168.1.15:5000",
  "192.168.1.15:5001",
  "192.168.1.15:5002",
  "192.168.1.15:5003"
};

// USB device
// COM port:baud rate
String[] serialAdapters = {
  "COM13:57600"
};

// Create adapters
Client[] adaptersNet = new Client[netAdapters.length];
Serial[] adaptersSerial = new Serial[serialAdapters.length];

// Panels
Panel[] panels = new Panel[2];

// Assets
PFont FlipDotFont;

// UI
int border = 40;


// Config setup
void config_setup() {
  // Load assets

  // Fonts
  FlipDotFont = createFont("fonts/zxSpectrumStrictCondensed.ttf", 15); // Good all round small font
  //FlipDotFont = createFont("fonts/PressStart2P.ttf", 8); // Stylish but large
  //FlipDotFont = createFont("fonts/PixeloidMono.ttf", 8); // Big and clear font
  //FlipDotFont = createFont("fonts/m3x6.ttf", 16); // Good general pixel font

  // Setup FlipDot panels
  createPanels();
}


void createPanels() {
  // Single 28x14 panel
  panels[0] = new Panel(0, 1, 0, 0);
  panels[1] = new Panel(0, 2, 0, 7);
  
  /**
   * Square display
   * Made up of 4 stacked panels
   *
  panels[0] = new Panel(0, 1, 0, 0);
  panels[1] = new Panel(0, 2, 0, 7);
  panels[2] = new Panel(0, 3, 0, 14);
  panels[3] = new Panel(0, 4, 0, 21);
   */

  /**
   * Large sqaure
   * 2x8 panels
   *
  panels[0]  = new Panel(0, 1, 0,  0);
  panels[1]  = new Panel(0, 2, 0,  7);
  panels[2]  = new Panel(0, 3, 0,  14);
  panels[3]  = new Panel(0, 4, 0,  21);
  panels[4]  = new Panel(1, 1, 28, 0);
  panels[5]  = new Panel(1, 2, 28, 7);
  panels[6]  = new Panel(1, 3, 28, 14);
  panels[7]  = new Panel(1, 4, 28, 21);
  panels[8]  = new Panel(2, 1, 0,  28);
  panels[9]  = new Panel(2, 2, 0,  35);
  panels[10] = new Panel(2, 3, 0,  42);
  panels[11] = new Panel(2, 4, 0,  49);
  panels[13] = new Panel(3, 1, 28, 28);
  panels[14] = new Panel(3, 2, 28, 35);
  panels[15] = new Panel(3, 3, 28, 42);
  panels[16] = new Panel(3, 4, 28, 49);
   */
   
  /**
   * Waterfall
   *
  panels[0] = new Panel(0, 1, 0, 0);
  panels[1] = new Panel(0, 2, 0, 7);
  panels[2] = new Panel(0, 3, 0, 14);
  panels[3] = new Panel(0, 4, 0, 21);

  panels[4] = new Panel(1, 1, 28, 28);
  panels[5] = new Panel(1, 2, 28, 35);
  panels[6] = new Panel(1, 3, 28, 42);
  panels[7] = new Panel(1, 4, 28, 49);

  panels[8] = new Panel(2, 1, 56, 56);
  panels[9] = new Panel(2, 2, 56, 63);
  panels[10] = new Panel(2, 3, 56, 70);
  panels[11] = new Panel(2, 4, 56, 77);

  panels[12] = new Panel(3, 1, 84, 84);
  panels[13] = new Panel(3, 2, 84, 91);
  panels[14] = new Panel(3, 3, 84, 98);
  panels[15] = new Panel(3, 4, 84, 105);
  */

  /**
   * Cross
   *
  panels[0] = new Panel(0, 1, 28, 0);
  panels[1] = new Panel(0, 2, 28, 7);
  panels[2] = new Panel(0, 3, 28, 14);
  panels[3] = new Panel(0, 4, 28, 21);

  panels[4] = new Panel(1, 1, 0, 28);
  panels[5] = new Panel(1, 2, 0, 35);
  panels[6] = new Panel(1, 3, 0, 42);
  panels[7] = new Panel(1, 4, 0, 49);

  panels[8] = new Panel(2, 1, 56, 28);
  panels[9] = new Panel(2, 2, 56, 35);
  panels[10] = new Panel(2, 3, 56, 42);
  panels[11] = new Panel(2, 4, 56, 49);

  panels[12] = new Panel(3, 1, 28, 56);
  panels[13] = new Panel(3, 2, 28, 63);
  panels[14] = new Panel(3, 3, 28, 70);
  panels[15] = new Panel(3, 4, 28, 77);

  panels[16] = new Panel(0, 5, 28, 28);
  panels[17] = new Panel(1, 5, 28, 35);
  panels[18] = new Panel(2, 5, 28, 42);
  panels[19] = new Panel(3, 5, 28, 49);
  */
}
