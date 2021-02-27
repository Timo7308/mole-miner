class Skeleton extends Opponent {
  private PImage imgLeft;
  private PImage imgRight;

  Skeleton(float x, float y) {
    super(x, y);

    imgLeft = loadImage("images/skeleton-left.png");
    imgRight = loadImage("images/skeleton-right.png");
    
    velocity.x = fiftyFifty() ? 70 : -70;
  }
  
  void draw() {
    updatePosition();
    image(velocity.x > 0 ? imgRight : imgLeft, position.x, position.y, Opponent.size, Opponent.size);
  }
}
