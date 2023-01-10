import processing.net.*;


/**
 * Setup casting
 *
 * - If casting is enabled, connected to the ETH-Serial converters.
 */
void cast_setup() {
  // Cast data
  if (!config_cast) return;

  // Connect to each network adapter
  for (int i = 0; i < adapters.length; i++) {
    String[] adapterAddress = split(adapters[i], ':');
    clients[i] = new Client(this, adapterAddress[0], int(adapterAddress[1]));
  }
}


/**
 * Cast data to display
 */
void cast_broadcast() {
  // Only if casting is enabled.
  if (!config_cast) return;

  // Push data to all adapters
  for (int adapter = 0; adapter < adapters.length; adapter++) {
    // Is panel connected?
    if (clients[adapter].ip() == null) continue;
    
    // Each panel connected to adapter
    for (int i = 0; i < panels.length; i++) {
      // Is this panel connected to this adapter
      if (panels[i].adapter != adapter) continue;

      // Only cast if panels data has changed
      // @TODO

      // Send data
      clients[adapter].write(0x80);
      clients[adapter].write((config_video_sync) ? 0x84 : 0x83);
      clients[adapter].write(panels[i].id);
      clients[adapter].write(panels[i].buffer);
      clients[adapter].write(0x8F);
    }
  }

  // Video sync update
  if (config_video_sync) {
    for (int adapter = 0; adapter < adapters.length; adapter++) {
      // If panel is not connected
      if (clients[adapter].ip() == null) break;

      // Refresh all panels command
      clients[adapter].write(0x80);
      clients[adapter].write(0x82);
      clients[adapter].write(0x8F);
    }
  }
}
