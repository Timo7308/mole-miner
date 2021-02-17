class Player {
  final private int size = 40;
  
  private PVector position;
  private PVector velocity;
  
  private boolean digging = false;
  
  private PImage img;
  
  Player(float x, float y) {
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.img = loadImage("images/mole.png");
  }
  
  void stop() {
    //digging = false;
    velocity.x = 0;
    //velocity.y = 0;
  }
  
  void moveRight() {
    velocity.x = 200;
  }
  
  void moveLeft() {
    velocity.x = -200;
  }
  
  void dig() {
    digging = true;
    velocity.y = 40;
  }
  
  void updatePosition() {
    // Apply gravity if the player is in the sky or a hole
    if (map.testTileInRect(position.x, position.y, size, size, "SE")) {
      velocity.y += 30; // gravity
    }
    
    PVector nextPosition = new PVector();
    nextPosition.x = position.x + velocity.x / frameRate;
    nextPosition.y = position.y + velocity.y / frameRate;
    
    //map.findClosestTileInRect(nextPosition.x, nextPosition.y, size, size, "DEGLRST");
    
    //map.at(nextPosition.x, nextPosition.y)
    
    if (map.testTileInRect(nextPosition.x, position.y, size, size, "R") ||
        nextPosition.x < 0 || nextPosition.x >= width) {
      velocity.x = 0;
      nextPosition.x = position.x;
    }
    
    if (!digging && map.testTileInRect(nextPosition.x, nextPosition.y, size, size, "DGRT") ||
        digging && map.testTileInRect(nextPosition.x, nextPosition.y, size, size, "R")) {
      velocity.y = 0;
      nextPosition.y = position.y;
      digging = false;
    }
    
    if (velocity.y > 700 || nextPosition.y > height) {
      gameState = LOST;
      return;
    }
    
    Map.TileReference closestGoldTile = map.findClosestTileInRect(nextPosition.x, nextPosition.y, size, size, "G");
    if (closestGoldTile != null) {
      goldCount++;
      map.set(closestGoldTile.x, closestGoldTile.y, 'D');
    }
    
    Map.TileReference closestTreasureTile = map.findClosestTileInRect(nextPosition.x, nextPosition.y, size, size, "T");
    if (closestTreasureTile != null) {
      gameState = WON;
    }
    
    position = nextPosition;
  }
  
  void draw() {
    updatePosition();
    
    image(img, position.x, position.y, size, size);
  }
}
