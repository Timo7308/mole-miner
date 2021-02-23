abstract class MovingObject {
  final protected int GRAVITY = 30;
  
  protected int objectWidth;
  protected int objectHeight;
  
  protected PVector position;
  protected PVector velocity;
  
  MovingObject(int objectWidth, int objectHeight, PVector position) {
    this.objectWidth = objectWidth;
    this.objectHeight = objectHeight;
    this.position = position;
    this.velocity = new PVector(0, 0);
  }
  
  protected void updatePosition() {
    Map.TileReference currentTile = getCurrentTile();
    
    if (currentTile == null) {
      println("warning: unable to obtain current tile");
      return;
    }
    
    // Apply gravity if the object is in the sky or a hole
    if ("SE".indexOf(currentTile.tile) != -1) {
      velocity.y += GRAVITY;
    }
    
    PVector nextPosition = new PVector();
    nextPosition.x = position.x + velocity.x / frameRate;
    nextPosition.y = position.y + velocity.y / frameRate;
    
    if (map.testTileInRect(nextPosition.x, position.y, objectWidth, objectHeight, "R") ||
        nextPosition.x < 0 || nextPosition.x >= width) {
      velocity.x = 0;
      nextPosition.x = position.x;
    }
    
    if (map.testTileInRect(nextPosition.x, nextPosition.y, objectWidth, objectHeight, "R")) {
      velocity.y = 0;
      nextPosition.y = position.y;
    }

    position = nextPosition;
  }
  
  protected Map.TileReference getCurrentTile() {
    return map.findClosestTileInRect(position.x, position.y, objectWidth, objectHeight, "DEFGLRST");
  }
}
