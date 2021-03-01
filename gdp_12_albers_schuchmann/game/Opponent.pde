/**
 * Represents an abstract opponent.
 */
abstract class Opponent extends MovingObject {
  final static private int size = 40;

  /**
   * Creates a new opponent with the given position.
   *
   * @param x the x coordinate of the position
   * @param y the y coordinate of the position
   */
  Opponent(float x, float y) {
    super(size, size, new PVector(x, y));
    
    velocity.x = fiftyFifty() ? 70 : -70;
  }
  
  protected void onHitEndX(PVector nextPosition) {
    float curVelocityX = velocity.x;
    super.onHitEndX(nextPosition);
    velocity.x = -curVelocityX;
  }
}
