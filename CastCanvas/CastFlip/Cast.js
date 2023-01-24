
class Cast {
  constructor(settings) {
    this.canvas = settings.canvas;
    this.blackWhiteSplit = settings.blackWhiteSplit;

    this.adapters = [];
    this.createApapters(settings.adapters);
  }


  createApapters(adapters) {
    adapters.forEach((adapter) => {
      this.adapters.push(new Adapter(adapter, this.canvas));
    });
  }



  /**
   * Cast canvas to matrix.
   * @param {DOM Canvas} canvas
   */
  cast(canvas) {
    const imageData = this.getImageData(canvas);

    this.adapters.forEach((adapter) => {
      adapter.cast(imageData);
    });
  }


  /**
   * Get image data and convert it into 2bit array.
   *
   * @param {HTML canvas} canvas
   * @returns {array/Int2} 2bit image array
   */
  getImageData(canvas) {
    const canvasData = this.getContext(canvas);
    return this.convertRGBtoBW(canvasData.data);
  }


  /**
   * Conver image to Black&White
   * @param {Array} data RGB image buffer array
   * @return {Array} Black & White image array (range: 0-1)
   */
  convertRGBtoBW(data) {
    const outputBW = [];

    // Loop over RGB array
    for (let i = 0; i < data.length; i += 4) {
      const grayscale = (data[i] * 0.3) + (data[i + 1] * 0.59) + (data[i + 2] * 0.11);
      outputBW.push(grayscale < this.blackWhiteSplit ? 0 : 1);
    }

    // Return Black/White array
    return outputBW;
  }


  /**
   * Gets the canvas context.
   * 2D or WebGL
   * @param {DOM Canvas} canvas HTML Canvas element
   * @return {Canvas context} canvas Canvas context
   */
  getContext(canvas) {
    let ctx;
    if (this.canvas.type === '2d') {
      ctx = canvas.getContext('2d');
      return ctx.getImageData(0, 0, this.canvas.width, this.canvas.height);
    }
    else if (this.canvas.type === 'webgl') {
      ctx = canvas.getContext('webgl', {
        antialias: false,
        depth: false,
      });
      return ctx.readPixels(0, 0, this.canvas.width, this.canvas.height);
    }
  }
}