import processing.net.*;
import processing.serial.*;


/**
 * Setup casting
 *
 * - If casting is enabled, connected to the ETH-Serial converters.
 */
void cast_setup() {
  // Cast data
  if (!config_cast) return;
  
  // Cast over Network
  if (castOver == 1) {
    // Connect to each network adapter
    for (int i = 0; i < netAdapters.length; i++) {
      String[] adapterAddress = split(netAdapters[i], ':');
      adaptersNet[i] = new Client(this, adapterAddress[0], int(adapterAddress[1]));
    }
  }
  // Cast over USB Serial device
  else if (castOver == 2) {
    // List all the available serial ports:
    //printArray(Serial.list());
    // Connect to each USB serial device
    for (int i = 0; i < serialAdapters.length; i++) {
      String[] adapterAddress = split(serialAdapters[i], ':');
      adaptersSerial[i] = new Serial(this, adapterAddress[0], int(adapterAddress[1]));
    }
  }
}


/**
 * Cast data to display
 */
void cast_broadcast() {
  // Only if casting is enabled.
  if (!config_cast) return;

  // Push data to all adapters
  int adapterCount = netAdapters.length;
  if (castOver == 2) {
    adapterCount = serialAdapters.length;
  }
    
  for (int adapter = 0; adapter < adapterCount; adapter++) {
    // Is panel connected?
    //if (netAdapterClients[adapter].ip() == null) continue;
    
    // Each panel connected to adapter
    for (int i = 0; i < panels.length; i++) {
      // Is this panel connected to this adapter
      if (panels[i].adapter != adapter) continue;

      // Only cast if panels data has changed
      // @TODO

      // Send data
      
      cast_write(adapter, 0x80);
      cast_write(adapter, (config_video_sync) ? 0x84 : 0x83);
      cast_write(adapter, panels[i].id);
      cast_write(adapter, panels[i].buffer);
      cast_write(adapter, 0x8F);
      
      //adaptersNet[adapter].write(0x80);
      //adaptersNet[adapter].write((config_video_sync) ? 0x84 : 0x83);
      //adaptersNet[adapter].write(panels[i].id);
      //adaptersNet[adapter].write(panels[i].buffer);
      //adaptersNet[adapter].write(0x8F);
    }
  }

  // Video sync update
  if (config_video_sync) {
    for (int adapter = 0; adapter < adapterCount; adapter++) {
      // If panel is not connected
      //if (netAdapterClients[adapter].ip() == null) break;

      // Refresh all panels command
      cast_write(adapter, 0x80);
      cast_write(adapter, 0x82);
      cast_write(adapter, 0x8F);
    //  adaptersNet[adapter].write(0x80);
    //  adaptersNet[adapter].write(0x82);
    //  adaptersNet[adapter].write(0x8F);
    }
  }
}

void cast_write(int adapter, int data) {
  if (castOver == 1) {
    // Network adapter
    adaptersNet[adapter].write(data);
  }
  else if(castOver == 2) {
    // USB Serial device
    adaptersSerial[adapter].write(data);
  }
}
void cast_write(int adapter, byte data) {
  cast_write(adapter, data);
}
void cast_write(int adapter, byte[] data) {
  if (castOver == 1) {
    // Network adapter
    adaptersNet[adapter].write(data);
  }
  else if(castOver == 2) {
    // USB Serial device
    adaptersSerial[adapter].write(data);
  }
}
