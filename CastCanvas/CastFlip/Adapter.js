/**
 * Adapter class
 *
 * Create FlipDot WebSocket adapter, builds frame data and casts.
 *
 * Expected data:
 * ip: IP address and port
 * id: Label for panel
 * panels: Array of panel IDs (eg.[0x01, 0x02, 0x03, 0x04])
 * mapping: Function to map pixel data
 * imageData: 2bit array of image data
 */
class Adapter {
  constructor(config, canvas) {
    this.id = config.id;
    this.ip = config.ip;
    this.panels = config.panels;
    this.mapping = config.mapping;
    this.canvas = canvas;
    this.imageData = [];

    this.wsOpen = false;
    this.ws = false;

    // Connect WS
    this.connect();
  }


  /**
   * Connect to WS deivce
   */
  connect() {
    // Open WebSocket connection
    this.ws = new WebSocket(`ws://${this.ip}`);
    this.ws.binaryType = 'arraybuffer';

    // WS open event
    this.ws.onopen = () => {
      // eslint-disable-next-line
      console.log(`Adapter ${this.id} WebSocket open`);
      this.wsOpen = true;
    };

    // WS closed event
    this.ws.onclose = () => {
      // eslint-disable-next-line
      console.log(`Adapter ${this.id} WebSocket closed`);
      this.wsOpen = false;
    };

    // WS error event
    this.ws.onerror = (evt) => {
      // eslint-disable-next-line
      console.log(`Adapter ${this.id} WebSocket error`);
      console.log(evt);
    };

    // WS message received
    this.ws.onmessage = (evt) => {
      // eslint-disable-next-line
      console.log(`Adapter ${this.id} WebSocket message: ${evt.data}`);
    };

    // Close connection on page exit.
    window.addEventListener('unload', e => {
      this.ws.close();
    });
  }


  /**
   * Cast frame of panels to adapter
   */
  cast(imageData) {
    // Is WS open?
    if (!this.wsOpen) {
      return;
    }

    // Update processed image data
    this.imageData = imageData;

    // Build frame buffer
    const buffer = this.frameBuffer();

    // Send data!
    this.ws.send(buffer);
  }


  /**
   * Build frame buffer
   *
   * @returns {Uint8Array} Frame buffer data
   */
  frameBuffer() {
    // Each panels data
    const adapterBuffer = [];
    this.panels.forEach((panel) => {
      adapterBuffer.push(...this.panelData(panel));
    });

    // Refresh all panels command
    const refreshAllPanels = [0x80, 0x82, 0x8F];
    adapterBuffer.push(...adapterBuffer, ...refreshAllPanels);

    // Return complete frame buffer
    return new Uint8Array(adapterBuffer);
  }


  /**
   * Build panel buffer.
   *
   * @param {int8} panel Panel number
   * @returns {Array(int8)} Frame data
   */
  panelData(panel) {
    // Panel header
    const bufferHeader = [
      0x80, // Start
      0x84, // Command 0x83 (28bits, Refresh, 28x7)
            // 0x84 (28bits, No refresh, 28x7) (requires a further 0x82 to refresh)
      panel,
    ];

    // Image data
    const bufferData = this.panelImageData(panel);

    // Closure
    const bufferFooter = [0x8F];

    // Concat all data
    return [...bufferHeader, ...bufferData, ...bufferFooter];
  }


  /**
   *
   * @param {*} panel
   * @returns
   */
  panelImageData(panel) {
    const panelBuffer = [];

    // Loop columns in panel
    for (let c = 0; c < 28; c++) {
      const positionX = c + this.mapping.offset.x;
      const positionY = ((panel - 1) * 7) + this.mapping.offset.y;
      const index = (positionY * this.canvas.width) + positionX;

      // Build uint8 byte
      const binary = [];
      for (let bit = 7 - 1; bit >= 0; bit--) {
        binary.push(this.imageData[index + (bit * this.canvas.width)]);
      }

      // Parse binary
      panelBuffer.push(parseInt(binary.join(''), 2));
    }

    return panelBuffer;
  }
}