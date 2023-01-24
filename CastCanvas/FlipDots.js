/**
 * FlipDots
 * Author: Owen McAteer
 * URL: https://github.com/owenmcateer/FlipDots
 *
 * FlipDot is a kinetic display I use for interactive art and animations.
 * This repo contains all the information and code to set one up and get
 * it connected to a computer.
 * This script will accept any image array buffer over WebSockets, desaturate
 * and scale to B/W, convert to FlipDot data and push out over USB.
 *
 * Usage
 * 1) Run `node install`
 * 2) Run `node FlipDots.js` and find your USB-to-RS485 adaptor port address.
 * 3) Open *FlipDots.js* and in config, enter this port address
 * 4) Still in *FlipDops.js* edit your panel settings (size & IDs)
 * 5) Again run `node FlipDots.js` and look for "Serial port opened and ready!"
 * 6) Now stream image data from Canvas Cast (https://github.com/owenmcateer/canvas-cast)
 *
 *
 * FlipDot DIP pin setup.
 * For more help see:
 * https://github.com/owenmcateer/FlipDots
 *
 * Baud-rate pins (3-pin DIP)
 * Value | ON  | Speed
 * ------|-----|--------
 *   0   | ↓↓↓ | N/A
 *   1   | ↑↓↓ | N/A
 *   2   | ↓↑↓ | N/A
 *   3   | ↑↑↓ | 9600
 *   4   | ↓↓↑ | 19200
 *   5   | ↑↓↑ | 38400
 *   6   | ↓↑↑ | 57600
 *   7   | ↑↑↑ | 9600
 * ------|-----|--------
 *       | OFF |
 *
 * Address (8-pin DIP)
 * This is the address ID used when pushing out the image data, each panel listents for its data.
 * Pins | Description
 * -----|--------------
 *  0-5 | Address in binary code (natural)
 *   6  | Magnetizing time: OFF: 500μs(default), ON: 450μs
 *   7  | Test mode: ON/OFF. OFF = normal operation
 * -----|--------------
 */

const config = {
  serialPort: '', // ie. (COM1, /dev/tty-usbserial1)
  baudRate: 19200,
  serverPort: 8081,
  // Panels
  cols: 28,
  rows: 7,
  panels: [0x01, 0x02],
  blackWhiteSplit: 127, // When to split black/white (0-255)
};

console.log('---\nWelcome to FlipDots\n---');

/**
 * Serial connection
 */
const SerialPort = require('serialport');
// List available serila devices
SerialPort.list().then((ports) => {
  console.log('---\nAvailable devices found:');
  ports.forEach((port) => {
    console.log(`${port.path}\t${port.manufacturer}`);
  });
  console.log('---');
});

// Connect to device
const serialDevice = new SerialPort(config.serialPort, {
  baudRate: config.baudRate,
  dataBits: 8,
  stopBits: 1,
  parity: 'none',
	timeout: 1,
});

// Serial device is reporting an error
serialDevice.on('error', (err) => {
  console.log('Serial port error: ', err.message);
  if (wsClient) {
    wsClient.send('Closed');
  }
});

// Serial device connection has opened
serialDevice.on('open', () => {
  console.log('Serial port opened and ready!');
  if (wsClient) {
    wsClient.send('Connected');
  }
});

// Serial device connection closed
serialDevice.on('close', () => {
  console.log('Serial port closed.');
  if (wsClient) {
    wsClient.send('Closed');
  }
});

// Message received from serial device
serialDevice.on('read', (msg) => {
  console.log('Serial message:');
  console.log(msg);
});


/**
 * WebSocket
 */
let wsClient;
const WebSocketServer = require('ws').Server;

// Start WebSocket Server
const wss = new WebSocketServer({port: config.serverPort});
console.log(`WebSocket running at: localhost:${config.serverPort}`);

// On connection
wss.on('connection', (client) => {
  // Only allow one client
  if (wsClient) {
    client.send('Busy');
    client.close();
    return;
  }

  // Welcome new user
  wsClient = client;
  wsClient.send('Connected');

  // On message
  wsClient.on('message', onMessage);

  // On close
  wsClient.on('close', () => onClose(client));
});

// On WS close
function onClose(client) {
  console.log('Client quit');
  client.send('Goodbye');
  wsClient = null;
}

// WebSocket has received a message/data
function onMessage(data) {
  switch (typeof data) {
    // Frame of data received as an object
    case 'object':
      // Process data
      flipDotProcessFrame(data);
    break;

    default:
      console.error(`Unknown data recieved of type: ${typeof data}`);
  }
}


/**
 * FlipDot
 */
function flipDotProcessFrame(data) {
  // Convert image to black & white
  const bwData = convertRGBtoBW(data);

  // Convert image to FlipDot binary
  const flipDotBufferHex = createBuffer(bwData);

  // Output panel
  for (let panel = 0; panel < flipDotBufferHex.length; panel++) {
    // Build image buffer
    const buffer = buildFrameBuffer(panel, flipDotBufferHex[panel]);

    // Send frame to device
    serialDevice.write(buffer);
  }

  // Refresh all displays
  serialDevice.write(Buffer.from([0x80, 0x82, 0x8F]));
}


/**
 * Conver image to Black&White
 * @param {Array} data RGB image buffer array
 * @return {Array} Black & White image array (range: 0-1)
 */
function convertRGBtoBW(data) {
  const outputBW = [];

  // Loop over RGB array
  for (let i = 0; i < data.length; i += 3) {
    const grayscale = (data[i] * 0.3) + (data[i + 1] * 0.59) + (data[i + 2] * 0.11);
    outputBW.push(grayscale < config.blackWhiteSplit ? 0 : 1);
  }

  // Return Black/White array
  return outputBW;
}


/**
 * Create FlipFot buffer split into panels.
 * Panels -> Column value.
 *
 * @param {Array} data 2bit image array
 * @return {Array} FlipDot panels and image buffer
 */
function createBuffer(data) {
  // How many panels?
  const panelBuffer = new Array(data.length / (config.rows * config.cols));

  // Loop panels
  for (let panel = 0; panel < panelBuffer.length; panel++) {
    panelBuffer[panel] = [];

    // Loop columns in panel
    for (let c = 0; c < config.cols; c++) {
      const index = (panel * config.rows * config.cols) + c;
      const binary = [];
      for (let bit = config.rows - 1; bit >= 0; bit--) {
        binary.push(data[index + (bit * config.cols)]);
      }
      // Parse binary
      panelBuffer[panel].push(parseInt(binary.join(''), 2));
    }
  }

  // Return completed buffer
  return panelBuffer;
}


/**
 * Build panel buffer to send.
 *
 * @param {int} panel Panel number.
 * @param {BufferArray} frameData Image data buffer array
 * @return {BufferArray} Buffer data ready to send to device
 */
function buildFrameBuffer(panel, frameData) {
  // Headers
  const dataHeader = Buffer.from([
    0x80, // Start
    0x84, // Command 0x83 (28bits, Refresh, 28x7)
          // 0x84 (28bits, No refresh, 28x7) (requires a further 0x82 to refresh)
    panel + 1,
  ]);

  // Footer
  const dataFooter = Buffer.from([0x8F]);

  // Concat all data
  const cmdBytearray = Buffer.concat([dataHeader, Buffer.from(frameData), dataFooter], dataHeader.length + frameData.length + dataFooter.length);

  // Return final buffer
  return cmdBytearray;
}
