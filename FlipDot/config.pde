/**
 * Config
 *
 * There are a few settings here you need to set here.
 *
 * Boolean `config_cast`
 *   true  = Cast data to display
 *   false = Run as a simulator
 *
 * Int `castOver`
 *   1 = ETH network
 *   2 = USB serial
 *
 * RS485 converter devices
 * Use their a ETH or USB serial device
 * ETH use {netAdapters}
 *   IP address:port
 * USB use {serialAdapters}
 *   COM port:baud rate
 *
 * Int `config_fps`
 *   Change if you want, I have found 30 fps work best for most displays.
 *
 * Bollean `config_video_sync`
 *   This setting tells the panels to wait until all data has been transmitted before refreshing. Good for syncing large displays
 *
 * Panel[] panels = new Panel[4];
 *   Set thei array size to the number of panels you have in your display.
 *
 * createPanels()
 *   Create a new panel for each one you have in your display
 *   `panels[0] = new Panel(0, 1, 0, 0);`
 *     1) Adapter ID (see net/serialAdapters)
 *     2) Panel ID (set on the 3-pin DIP switch)
 *     3) X-position in total display
 *     4) Y-position in total display
 *
 * Boolean config_show_simulator
 *   Show/Hide the UI simulator.
 */
boolean config_cast = false;
int config_fps = 30;
int config_canvasW;
int config_canvasH;
boolean config_video_sync = true;
boolean config_show_simulator = true;

// Network settings
//   1 = ETH network
//   2 = USB serial
int castOver = 1;

// Panels
Panel[] panels = new Panel[4];

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

// Assets
PFont FlipDotFont;
PFont FlipDotFont_pixel;

// UI
int border = 40;

/**
 * Config setup
 */
void config_setup() {
  // Load assets

  // Fonts
  FlipDotFont = createFont("fonts/zxSpectrumStrictCondensed.ttf", 15); // Good all round small font
  //FlipDotFont = createFont("fonts/PressStart2P.ttf", 8); // Stylish but large
  //FlipDotFont = createFont("fonts/PixeloidMono.ttf", 8); // Big and clear font
  FlipDotFont_pixel = createFont("fonts/m3x6.ttf", 16); // Good general pixel font

  // Setup FlipDot panels
  createPanels();
}


/**
 * Create FlipDot panels
 *
 * List all panels you have in your display.
 * `panels[0] = new Panel(0, 1, 0, 0);`
 *  1) Adapter ID (see net/serialAdapters)
 *  2) Panel ID (set on the 3-pin DIP switch)
 *  3) X-position in total display
 *  4) Y-position in total display
 *
 * You can use the example layouts below or create your own.
 */
void createPanels() {
  /**
   * Single 28x14 panel
   *
  panels[1] = new Panel(0, 2, 0, 7);
   */

  /**
   * Square display
   * Made up of 4 stacked panels
   */
  panels[0] = new Panel(0, 1, 0, 0);
  panels[1] = new Panel(0, 2, 0, 7);
  panels[2] = new Panel(0, 3, 0, 14);
  panels[3] = new Panel(0, 4, 0, 21);

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

  panels[12] = new Panel(3, 1, 28, 28);
  panels[13] = new Panel(3, 2, 28, 35);
  panels[14] = new Panel(3, 3, 28, 42);
  panels[15] = new Panel(3, 4, 28, 49);
   */

  /**
   * Waterfall
   *
  panels[0]  = new Panel(0, 1, 0,  0);
  panels[1]  = new Panel(0, 2, 0,  7);
  panels[2]  = new Panel(0, 3, 0,  14);
  panels[3]  = new Panel(0, 4, 0,  21);

  panels[4]  = new Panel(1, 1, 28, 28);
  panels[5]  = new Panel(1, 2, 28, 35);
  panels[6]  = new Panel(1, 3, 28, 42);
  panels[7]  = new Panel(1, 4, 28, 49);

  panels[8]  = new Panel(2, 1, 56, 56);
  panels[9]  = new Panel(2, 2, 56, 63);
  panels[10] = new Panel(2, 3, 56, 70);
  panels[11] = new Panel(2, 4, 56, 77);

  panels[12] = new Panel(3, 1, 84, 84);
  panels[13] = new Panel(3, 2, 84, 91);
  panels[14] = new Panel(3, 3, 84, 98);
  panels[15] = new Panel(3, 4, 84, 105);
  */

  /**
   * Superwide
   * 4x2 panels
   *
  panels[0]  = new Panel(0, 1, 0,  0);
  panels[1]  = new Panel(0, 2, 0,  7);
  panels[2]  = new Panel(0, 3, 0,  14);
  panels[3]  = new Panel(0, 4, 0,  21);

  panels[4]  = new Panel(1, 1, 28, 0);
  panels[5]  = new Panel(1, 2, 28, 7);
  panels[6]  = new Panel(1, 3, 28, 14);
  panels[7]  = new Panel(1, 4, 28, 21);

  panels[8]  = new Panel(2, 1, 56,  0);
  panels[9]  = new Panel(2, 2, 56,  7);
  panels[10] = new Panel(2, 3, 56,  14);
  panels[11] = new Panel(2, 4, 56,  21);

  panels[12] = new Panel(3, 1, 84, 0);
  panels[13] = new Panel(3, 2, 84, 7);
  panels[14] = new Panel(3, 3, 84, 14);
  panels[15] = new Panel(3, 4, 84, 21);
   */

  /**
   * Cross
   *
  panels[0]  = new Panel(0, 1, 28, 0);
  panels[1]  = new Panel(0, 2, 28, 7);
  panels[2]  = new Panel(0, 3, 28, 14);
  panels[3]  = new Panel(0, 4, 28, 21);

  panels[4]  = new Panel(1, 1, 0,  28);
  panels[5]  = new Panel(1, 2, 0,  35);
  panels[6]  = new Panel(1, 3, 0,  42);
  panels[7]  = new Panel(1, 4, 0,  49);

  panels[8]  = new Panel(2, 1, 56, 28);
  panels[9]  = new Panel(2, 2, 56, 35);
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

  // Find largest width value in panels above
  for (int i = 0; i < panels.length; i++) {
    if (panels[i].x + 28 > config_canvasW) {
      config_canvasW = panels[i].x + 28;
    }
    if (panels[i].y + 7 > config_canvasH) {
      config_canvasH = panels[i].y + 7;
    }
  }
}
