// Config
boolean config_cast = false;
int config_fps = 30;
int config_canvasW = 28;
int config_canvasH = 28;
boolean config_video_sync = true;

// Assets
PFont FlipDotFont;

// UI
int border = 40;

String[] adapters = {
  "192.168.1.15:5000",
  "192.168.1.15:5001",
  "192.168.1.15:5002",
  "192.168.1.15:5003"
};
Client[] clients = new Client[adapters.length];
Panel[] panels = new Panel[4];


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
  // Single panel
  panels[0] = new Panel(0, 1, 0, 0);
  panels[1] = new Panel(1, 1, 0, 7);
  panels[2] = new Panel(2, 1, 0, 14);
  panels[3] = new Panel(3, 1, 0, 21);
}
