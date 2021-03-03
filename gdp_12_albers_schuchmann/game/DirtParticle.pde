/**
 * Represents a particle of dirt, produced by digging.
 */
class DirtParticle extends MovingObject {
  final protected int GRAVITY = 0;
  
  int startTime = millis();
  
  /**
   * Creates a new dirt particle with the given position.
   *
   * @param position the initial position of the dirt particle
   */
  DirtParticle(PVector position) {
    super(0, 0, position);
    velocity = new PVector(random(-200, 200), random(30, 50));
    objectWidth = objectHeight = (int)random(3, 10);
  }
  
  /**
   * Draws the particle of dirt.
   */
  void draw() {
    super.updatePosition();
    
    float lowerY = position.y + 20;
    Map.TileReference lowerTile = map.findClosestTileInRect(position.x, lowerY, objectWidth, objectHeight, "R");
    if (lowerTile != null) {
      velocity.x = 0;
    }
    
    noStroke();
    fill(#6e4836, 100);
    circle(position.x, position.y, objectWidth);
  }
}
