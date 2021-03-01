/**
 * Represents a bat.
 */
class Bat extends Opponent {
  private PImage img;

  /**
   * Creates a new bat with the given position.
   *
   * @param x the x coordinate of the position
   * @param y the y coordinate of the position
   */
  Bat(float x, float y) {
    super(x, y);
    
    canFly = true;
    img = loadImage("images/bat.gif");
    
    velocity.x = fiftyFifty() ? 70 : -70;
  }
  
  void draw() {
    updatePosition();
    
    pushMatrix();
    if (velocity.x > 0) {
      // Flip image
      translate(position.x+Opponent.size, position.y);
      scale(-1,1);
    } else {
      translate(position.x, position.y);
    }
    
    image(img, 0, 0, Opponent.size, Opponent.size);
    popMatrix();
  }
}
