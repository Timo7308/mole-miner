class Bat extends Opponent {
  private PImage img;

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
