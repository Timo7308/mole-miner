/**
 * Represents a hole in the dirt, produced by digging.
 */
class DirtHole {
  private PVector position;
  private int size;
  
  /**
   * Creates a new dirt hole for the given tile
   *
   * @param tile the tile to randomly position the hole on
   */
  DirtHole(Map.TileReference tile) {
    size = (int)random(2, 26);
    this.position = new PVector(
      random(tile.left+size/2, tile.right-size/2),
      random(tile.top+size/2, tile.bottom-size/2)
    );
    
  }
  
  void draw() {
    noStroke();
    fill(0, 50);
    circle(position.x, position.y, size);
  }
}
