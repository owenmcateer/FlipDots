/**
 * Tetris game in Processing for FlipDot display
 *
 * Settings:
 * Tetris().speed = 2.0; // Game speed
 * Tetris().scale = 2; // Scale of game(per-dot)
 * Tetris().board_width = 14; // Width of game board
 * Tetris().board_height = 14; // Height of game board
 *
 */
Tetris tetris = new Tetris();

// Tetris game tick
void games_tetris() {
  tetris.update();
  tetris.draw();
}

/**
 * Tetris game class
 */
class Tetris {
  Tetromino tetromino;

  // Game settings
  int status = 0; // 0 = playing, 1 = game over, 2 = line removing
  float speed = 2.0;
  int scale = 2;
  int board_width = 14;
  int board_height = 14;
  int[] board;

  // Input settings
  int input_delay = 70; // ms
  boolean input_down = false;
  boolean input_left = false;
  boolean input_right = false;
  int input_down_time = 0;
  int input_strafe_time = 0;

  // Misc vars
  float anim_progress = 0.0;
  int remove_line;

  Tetris() {
    this.restart();
  }

  // State: Playing tick
  void tick_playing() {
    // Check inputs
    this.check_input();

    // Game tick
    if (frameCount % round(config_fps / this.speed) == 0) {
      this.move('t');
    }
    // Check for completed rows
    this.check_rows();
  }

  // Check rows for completed rows
  void check_rows() {
    // Check for completed rows
    for (int y = this.board_height - 1; y >= 0; y--) {
      boolean row_complete = true;
      for (int x = 0; x < this.board_width; x++) {
        if (this.board[x + y * this.board_width] == 0) {
          row_complete = false;
        }
      }
      if (row_complete) {
        this.remove_line(y);
        break;
      }
    }
  }

  // Remove completed rows
  void remove_line(int line) {
    // Remove line
    this.status = 2;
    this.remove_line = line;

    // Increase speed
    this.speed += 0.1;
  }

  // Draw tick for removing lines
  void draw_removing_line() {
    if (this.anim_progress < 1) {
      this.draw_board();
      // Animate line scrolling across removed live
      virtualDisplay.fill(0);
      virtualDisplay.rect(
        0,
        this.remove_line * this.scale,
        virtualDisplay.width * 2.0 * this.anim_progress,
        this.scale
      );
      this.anim_progress += 0.05;
    }
    else {
      // When animation finished, Remove row
      for (int x = 0; x < this.board_width; x++) {
        this.board[x + this.remove_line * this.board_width] = 0;
      }
      // Move all rows above down
      for (int y = this.remove_line; y > 0; y--) {
        for (int x = 0; x < this.board_width; x++) {
          this.board[x + y * this.board_width] = this.board[x + (y - 1) * this.board_width];
        }
      }
      // Contine game play
      this.anim_progress = 0.0;
      this.status = 0;
      this.remove_line = -1;
      // Draw updated board
      this.draw_board();
    }
  }

  // Draw: State: Game over
  void tick_game_over() {
    this.draw_board();
    virtualDisplay.fill(255);
    virtualDisplay.rect(0, virtualDisplay.height - (this.anim_progress * virtualDisplay.height * 2.0), virtualDisplay.width, virtualDisplay.height);
    if (this.anim_progress > 0.5) {
      this.board = new int[this.board_width * this.board_height];

      // Game over text
      virtualDisplay.fill(255);
      virtualDisplay.textFont(FlipDotFont_pixel);
      virtualDisplay.textLeading(7);
      virtualDisplay.textAlign(CENTER);
      virtualDisplay.text("Game\nOver", virtualDisplay.width / 2 + 1, virtualDisplay.height / 4.0);

      // Restart text
      if (frameCount % 15 < 11) {
        virtualDisplay.textAlign(CENTER, CENTER);
        virtualDisplay.text("start", virtualDisplay.width / 2 + 1, virtualDisplay.height / 1.5);
      }
    }

    // Animate
    if (this.anim_progress < 1) {
      this.anim_progress += 0.03;
    }
  }

  // Interaction
  void check_input() {
    // Down
    if (this.input_down && millis() - this.input_down_time > this.input_delay) {
      this.move('d');
      this.input_down_time = millis();
    }

    // Left/Right
    if (this.input_left && millis() - this.input_strafe_time > this.input_delay) {
      this.move('l');
      this.input_strafe_time = millis();
    }
    else if (this.input_right && millis() - this.input_strafe_time > this.input_delay) {
      this.move('r');
      this.input_strafe_time = millis();
    }
  }

  // Move tetromino
  void move(char direction) {
    switch (direction) {
      case 'l':
        // Move & check collision
        this.tetromino.move('l');
        if (this.check_collisions()) {
          this.tetromino.move('r');
        }
      break;

      case 'r':
        // Move & check collision
        this.tetromino.move('r');
        if (this.check_collisions()) {
          this.tetromino.move('l');
        }
      break;

      case 'd':
        // Move & check collision
        this.tetromino.move('d');
        if (this.check_collisions()) {
          this.tetromino.move('u');
        }
      break;

      // Game tick (down)
      case 't':
        // Move & check collision
        this.tetromino.move('d');
        if (this.check_collisions()) {
          this.tetromino.move('u');
          this.lock_tetromino();
          this.new_tetromino();
        }
      break;
    }
  }

  // Create a new tetromino
  void new_tetromino() {
    // Create new tetromino
    this.tetromino = new Tetromino(this);
    if (this.check_collisions()) {
      this.status_gameover();
    }
  }

  // Change game state: Game over
  void status_gameover () {
    this.status = 1;
    this.anim_progress = 0;
  }

  // Rotate tetromino
  void rotate() {
    // Rotate & check collision
    this.tetromino.rotate(1);
    if (this.check_collisions()) {
      this.tetromino.rotate(-1);
    }
  }

  // Once collision detected, lock tetromino to board
  void lock_tetromino() {
    // Lock tetromino to board
    for (int i = 0; i < this.tetromino.pixelMap.length; i += 2) {
      int x = this.tetromino.pixelMap[i];
      int y = this.tetromino.pixelMap[i + 1];
      int index = x + y * this.board_width;
      if (index > 0 && index < this.board.length) {
        this.board[index] = 1;
      }
    }
  }

  // Check if tetromino collides
  boolean check_collisions() {
    // Check tetromino collision
    // Check each pixel of tetromino
    for (int i = 0; i < this.tetromino.pixelMap.length; i += 2) {
      int x = this.tetromino.pixelMap[i];
      int y = this.tetromino.pixelMap[i + 1];

      // Check if pixel is out of bounds
      if (x < 0) {
        return true;
      }
      if (x >= this.board_width) {
        return true;
      }

      // Hit floor
      if (y >= this.board_height) {
        return true;
      }

      // Check if pixel is already occupied
      int index = x + y * this.board_width;
      if (index > 0 && index < this.board.length && this.board[index] > 0) {
        return true;
      }
    }
    return false;
  }

  // Game update
  void update() {
    switch (this.status) {
      case 0:
        this.tick_playing();
      break;
    }
  }

  // Draw tick
  void draw() {
    virtualDisplay.background(0);

    switch (this.status) {
      case 0:
        this.draw_board();
        this.draw_tetromino();
      break;

      case 1:
        this.tick_game_over();
      break;

      // Removing line
      case 2:
        this.draw_removing_line();
      break;
    }
  }

  // Draw tetris board
  void draw_board() {
    virtualDisplay.noStroke();

    // Draw current tetromino
    for (int i = 0; i < board.length; i++) {
      int x = i % this.board_width;
      int y = floor(i / this.board_height);
      virtualDisplay.fill(round(board[i] * 255));
      virtualDisplay.rect(
        x * this.scale,
        y * this.scale,
        this.scale,
        this.scale
      );
    }
  }

  // Draw current tetromino
  void draw_tetromino() {
    virtualDisplay.fill(255);
    virtualDisplay.noStroke();

    // Draw current tetromino
    for (int i = 0; i < this.tetromino.render().length; i += 2) {
      virtualDisplay.rect(
        this.tetromino.render()[i] * this.scale,
        this.tetromino.render()[i + 1] * this.scale,
        this.scale,
        this.scale
      );
    }
  }

  // Restart game
  void restart() {
    this.status = 0;
    this.speed = 2.0;
    this.board = new int[this.board_width * this.board_height];
    this.new_tetromino();
  }
}


/**
 * Tetromino class
 */
class Tetromino {
  int type;
  int x;
  int y;
  int r;
  int[] pixelMap;
  int[][][] tetris_tetrominos = {
    // I
    {
      {0,0,-1,0,-2,0,1,0},
      {0,0,0,-1,0,1,0,2},
      {0,1,1,1,-1,1,-2,1},
      {-1,0,-1,-1,-1,1,-1,2},
    },
    // J
    {
      {0,0,-1,0,1,0,-1,-1},
      {0,0,0,-1,1,-1,0,1},
      {0,0,-1,0,1,0,1,1},
      {0,0,0,-1,0,1,-1,1}
    },
    // L
    {
      {0,0,-1,0,1,0,1,-1},
      {0,0,0,-1,0,1,1,1},
      {0,0,-1,0,-1,1,1,0},
      {0,0,0,-1,-1,-1,0,1}
    },
    // O
    {
      {0,0,-1,0,-1,1,0,1},
      {0,0,-1,0,-1,1,0,1},
      {0,0,-1,0,-1,1,0,1},
      {0,0,-1,0,-1,1,0,1}
    },
    // S
    {
      {0,0,-1,0,0,-1,1,-1},
      {0,0,0,-1,1,0,1,1},
      {0,0,1,0,0,1,-1,1},
      {0,0,-1,0,-1,-1,0,1}
    },
    // T
    {
      {0,0,0,-1,-1,0,1,0},
      {0,0,0,-1,0,1,1,0},
      {0,0,-1,0,1,0,0,1},
      {0,0,-1,0,0,-1,0,1}
    },
    // 2
    {
      {0,0,0,-1,-1,-1,1,0},
      {0,0,0,1,1,0,1,-1},
      {0,0,-1,0,0,1,1,1},
      {0,0,0,-1,-1,0,-1,1}
    }
  };

  Tetromino(Tetris tetris) {
    this.type = floor(random(this.tetris_tetrominos.length));
    this.x = round(tetris.board_width / 2.0);
    this.y = -1;
    this.r = 0;
    this.pixelMap = new int[8];

    this.update_pixels();
  }

  // Move tetromino
  void move(char dir) {
    switch (dir) {
      case 'l':
        this.x--;
      break;
      case 'r':
        this.x++;
      break;
      case 'd':
        this.y++;
      break;
      case 'u':
        this.y--;
      break;
    }
    this.update_pixels();
  }

  // Rotate tetromino
  void rotate(int direction) {
    this.r = (this.r + direction + 4) % 4;
    this.update_pixels();
  }

  // Update pixel map for display
  void update_pixels() {
    for (int i = 0; i < this.tetris_tetrominos[this.type][this.r].length; i += 2) {
      this.pixelMap[i] = this.tetris_tetrominos[this.type][this.r][i] + this.x;
      this.pixelMap[i + 1] = this.tetris_tetrominos[this.type][this.r][i + 1] + this.y;
    }
  }

  // Return pixel map
  int[] render() {
    return this.pixelMap;
  }
}


/**
* Key presses for Tetris
*
* This is a global listener for key presses.
* if you want to use key presses elsewhere in your own code
* you will need to extend of rename these functions.
*/
void keyPressed() {
  // Down
  if (keyCode == DOWN) {
    tetris.move('d');
    tetris.input_down = true;
    tetris.input_down_time = millis();
  }

  // Left or Right
  if (keyCode == LEFT) {
    tetris.move('l');
    tetris.input_left = true;
    tetris.input_strafe_time = millis();
  }
  else if (keyCode == RIGHT) {
    tetris.move('r');
    tetris.input_right = true;
    tetris.input_strafe_time = millis();
  }

  // New game/start
  if (keyCode == ENTER && tetris.status != 0) {
    tetris.restart();
  }

  // Rotate
  if (keyCode == UP) {
    tetris.rotate();
  }
}

// Key releases for Tetris
void keyReleased() {
  // Down
  if (keyCode == DOWN) {
    tetris.input_down = false;
  }
  // Left
  if (keyCode == LEFT) {
    tetris.input_left = false;
  }
  // Right
  if (keyCode == RIGHT) {
    tetris.input_right = false;
  }
}
