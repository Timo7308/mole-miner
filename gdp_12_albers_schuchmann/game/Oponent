class Oponent extends MovingObject {

  final static private int size = 40;
  private PImage img;

  Oponent(float x, float y) {
    super(size, size, new PVector(x, y+50));

    this.img = loadImage("images/bat.gif");
  }

  void moveRight() {
    velocity.x = 70;
  }

  void moveLeft() {
    velocity.x = -70;
  }
  void stop() {
    velocity.x = 0;
  }


  void draw() {

    updatePosition();
    image(img, position.x, position.y, size, size);
  }

  protected void updatePosition() {
    super.updatePosition();

    if (position.x == 150 && position.y == 259) {
      moveRight();
    }
    if (position.x >= 350) {
      moveLeft();
    }
    if (position.x <= 150) {
      moveRight();
    }
  }
}
