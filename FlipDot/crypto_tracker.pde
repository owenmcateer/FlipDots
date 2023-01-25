import websockets.*;
import java.text.DecimalFormat;


WebsocketClient wsc;
ArrayList<Cryptocurrency> coins = new ArrayList<Cryptocurrency>();
ArrayList<String> tokens = new ArrayList<String>();
static final DecimalFormat dfZero = new DecimalFormat("0.00");


/**
 * Realtime crypto feed
 *
 * An example of reading and outputting a realtime WebSockets api feed.
 */
void crypto_ticker_setup() {
  wsc = new WebsocketClient(this, "wss://ws.kraken.com");

  // Tokens
  tokens.add("BTC/EUR");
  tokens.add("ETH/EUR");
  //tokens.add("BCH/USD");
  //tokens.add("LTC/USD");
  //tokens.add("USDT/USD");
  //tokens.add("USDC/USD");
  //tokens.add("XRP/USD");
  //tokens.add("ADA/USD");
  //tokens.add("SOL/USD");
  //tokens.add("DOGE/USD");
  //tokens.add("DOT/USD");
  //tokens.add("MATIC/USD");
  //tokens.add("XTZ/USD");
  //tokens.add("MANA/USD");

  // Subscribe message
  String subMessage = "{ \"event\": \"subscribe\",";
  subMessage += "\"subscription\": { \"name\": \"ticker\"  },";
  subMessage += "\"pair\": [";
  // Add coin pairs
  for (int i = 0; i < tokens.size(); i++) {
    subMessage += "\"" + tokens.get(i) + "\"";
    if (i < tokens.size() - 1) {
      subMessage += ", ";
    }
  }
  subMessage += "]}";

  // Send subscribe message
  wsc.sendMessage(subMessage);
}

/**
 * Output realtime data
 */
void crypto_ticker() {
  virtualDisplay.background(0);
  virtualDisplay.fill(255);
  virtualDisplay.noStroke();
  
  virtualDisplay.textFont(FlipDotFont);
  
  for (int i = 0; i < coins.size(); i++) {
    Cryptocurrency coinPair = coins.get(i);
    virtualDisplay.text(coinPair.symbol.toLowerCase(), 0, i * 15 + 6);
    virtualDisplay.text(coinPair.value, 0, i * 15 + 12);
  }
}


/**
 * Read and parse data
 * @see https://docs.kraken.com/websockets/#message-ticker
 */
void webSocketEvent(String msg){
  if (msg.charAt(0) == '[') {
    // Update array
    JSONArray krakenJson = parseJSONArray(msg);
    int coinId = krakenJson.getInt(0);
    JSONObject tickerData = krakenJson.getJSONObject(1);
    JSONArray askData = tickerData.getJSONArray("a");
    // Update coin value
    findCoinById(coinId).updateValue(askData.getFloat(0));
  }
  else if(msg.charAt(0) == '{') {
    JSONObject json = parseJSONObject(msg);

    if (json == null) {
      println("JSONObject could not be parsed");
      println(msg);
    } else {
      // Event
      String event = json.getString("event");

      // Subscription
      if (event.equals("subscriptionStatus")) {
        int channelID = json.getInt("channelID");
        String pair = json.getString("pair");
        coins.add(new Cryptocurrency(channelID, pair));
      }
    }
  }
}


/**
 * Cryptocurrency class for each sub 
 */
class Cryptocurrency {
  int id;
  String symbol;
  String value;

  Cryptocurrency(int coinId, String coinSymbol) {
    id = coinId;
    symbol = coinSymbol.substring(0, coinSymbol.indexOf("/"));
    value = "-";
    if (symbol.equals("XBT")) {
      symbol = "BTC";
    }
  }

  int getId() {
    return id;
  }

  void updateValue(float newValue) {
    value = dfZero.format(newValue);
  }
}

/**
 * Find coin by Id
 */
public Cryptocurrency findCoinById(int id) {
  for (Cryptocurrency coin : coins) {
    if (coin.getId() == id) {
      return coin;
    }
  }
  return null;
}
