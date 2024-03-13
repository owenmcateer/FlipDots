/**
 * Example: Cluster Growth
 *
 * Simple cluster growth model algorithm.
 */
class ClusterGrowth {
  int[][] grid = new int[virtualDisplay.width + 1][virtualDisplay.height + 1];
  float growthProbability;
  int holdTime = 120;

  ClusterGrowth() {
    init();
  }

  void init() {
    holdTime = 120;
    growthProbability = random(0.05, 0.2);
    grid = createEmptyGrid();
    seedCluster(floor(random(virtualDisplay.width)), floor(random(virtualDisplay.height)), 2);
  }

  void draw() {
    virtualDisplay.background(0);
    virtualDisplay.stroke(255);
    virtualDisplay.strokeWeight(1);
    updateGrid();
    displayGrid();

    // Check end state
    int totalGrid = virtualDisplay.width * virtualDisplay.height;
    int totalSum = 0;
    for (int i = 0; i < virtualDisplay.width; i++) {
      for (int j = 0; j < virtualDisplay.height; j++) {
        totalSum += grid[i][j];
      }
    }
    // Reset
    if (totalGrid >= totalSum) {
      holdTime--;
      if (holdTime < 0) {
        init();
      }
    }
  }

  void updateGrid() {
    int[][] updatedGrid = createEmptyGrid();

    for (int i = 1; i < grid.length - 1; i++) {
      for (int j = 1; j < grid[0].length - 1; j++) {
        int neighbors = countNeighbors(grid, i, j);

        if (grid[i][j] == 0 && neighbors > 0) {
          if (random(1) < growthProbability) {
            updatedGrid[i][j] = 1;
          }
        } else {
          updatedGrid[i][j] = grid[i][j];
        }
      }
    }
    grid = updatedGrid;
  }

  void displayGrid() {
    for (int x = 0; x < virtualDisplay.width; x++) {
      for (int y = 0; y < virtualDisplay.height; y++) {
        if (grid[x][y] == 1) {
          virtualDisplay.point(x, y);
        }
      }
    }
  }

  int[][] createEmptyGrid() {
    int[][] emptyGrid = new int[virtualDisplay.width + 1][virtualDisplay.height + 1];
    for (int i = 0; i < emptyGrid.length; i++) {
      for (int j = 0; j < emptyGrid[0].length; j++) {
        emptyGrid[i][j] = 0;
      }
    }
    return emptyGrid;
  }

  int countNeighbors(int[][] grid, int x, int y) {
    int sum = 0;
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        sum += grid[x + i][y + j];
      }
    }
    sum -= grid[x][y];
    return sum;
  }

  void seedCluster(int x, int y, int size) {
    for (int i = x - size / 2; i < x + size / 2; i++) {
      for (int j = y - size / 2; j < y + size / 2; j++) {
        if (i >= 0 && i < virtualDisplay.width && j >= 0 && j < virtualDisplay.height) {
          grid[i][j] = 1;
        }
      }
    }
  }
}
