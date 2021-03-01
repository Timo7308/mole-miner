/**
 * Represents a skeleton.
 */
class Skeleton extends Opponent {
  private PImage imgLeft;
  private PImage imgRight;

  /**
   * Creates a new skeleton with the given position.
   *
   * @param x the x coordinate of the position
   * @param y the y coordinate of the position
   */
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
