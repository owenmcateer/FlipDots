let cast;
let img;


function preload() {
  img = loadImage('Mona-Lisa.png')
}


function setup() {
  createCanvas(28, 28);
  pixelDensity(1);

  display = {
    adapters: [
      {
        ip: '192.168.1.21:8000',
        id: '#1',
        panels: [0x01, 0x02, 0x03, 0x04],
        mapping: {
          offset: {
            x: 0,
            y: 0
          }
        },
      }
    ],
    blackWhiteSplit: 127,
    canvas: {
      type: '2d',
      width: 28,
      height: 28
    }
  };

  // Start WS Matrix
  cast = new Cast(display);


  frameRate(15);
}


function draw() {
  background(0);

  image(img, 0, 0);
  // stroke(255);
  // strokeWeight(2);
  // translate(width / 2, height / 2);
  // rotate(frameCount / 20);
  // strokeWeight(2);
  // stroke(255);
  // line(-width, 0, width, 0);
  // line(0, -height, 0, height);



  // Cast data
  const p5canvas = document.getElementById('defaultCanvas0');
  cast.cast(p5canvas);
}


