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
  
  void draw() {
    // Apply gravity if the player is in the sky or a hole
    if (map.testTileInRect(position.x, position.y, size, size, "SE")) {
      velocity.y += 30; // gravity
    }
    
    PVector nextPosition = new PVector();
    nextPosition.x = position.x + velocity.x / frameRate;
    nextPosition.y = position.y + velocity.y / frameRate;
    
    if (!digging && map.testTileInRect(nextPosition.x, nextPosition.y, size, size, "DGRT") ||
      digging && map.testTileInRect(nextPosition.x, nextPosition.y, size, size, "R")) {
      velocity = new PVector(velocity.x, 0);
      nextPosition.y = position.y;
      digging = false;
    }
    
    if (velocity.y > 700) {
      gameState = LOST;
      return;
    }
    
    position = nextPosition;
    
    image(img, position.x, position.y, size, size);
  }
}
