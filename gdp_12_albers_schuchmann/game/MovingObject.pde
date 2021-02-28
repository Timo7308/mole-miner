abstract class MovingObject {
  final protected int GRAVITY = 30;
  
  protected boolean canFly = false;
  
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
  
  abstract void draw();
  
  boolean collidesWith(MovingObject m2) {
    boolean collidesHorizontal = position.x+objectWidth >= m2.position.x && position.x <= m2.position.x+m2.objectWidth;
    boolean collidesVertical = position.y+objectHeight >= m2.position.y && position.y <= m2.position.y+m2.objectHeight;
    return collidesHorizontal && collidesVertical;
  }
  
  protected void updatePosition() {
    Map.TileReference currentTile = getCurrentTile();
    
    // Apply gravity if the object cannot fly and is in the sky or a hole
    if (!canFly && "SE".indexOf(currentTile.tile) != -1) {
      velocity.y += GRAVITY;
    }
    
    PVector nextPosition = new PVector();
    nextPosition.x = position.x + velocity.x / frameRate;
    nextPosition.y = position.y + velocity.y / frameRate;
    
    if (map.testTileInRect(nextPosition.x, position.y, objectWidth, objectHeight, "R") ||
        nextPosition.x < 0 || nextPosition.x >= width-1) {
      onHitEndX(nextPosition);
    }
    
    if (map.testTileInRect(nextPosition.x, nextPosition.y, objectWidth, objectHeight, "R")) {
      onHitEndY(nextPosition);
    }

    nextPosition.x = constrain(nextPosition.x, 0, width-objectWidth);
    nextPosition.y = constrain(nextPosition.y, 0, height-objectHeight);
    position = nextPosition;
  }
  
  protected void onHitEndX(PVector nextPosition) {
    velocity.x = 0;
    nextPosition.x = position.x;
  }
  
  protected void onHitEndY(PVector nextPosition) {
    velocity.y = 0;
    nextPosition.y = position.y;
  }
  
  protected Map.TileReference getCurrentTile() {
    return map.findClosestTileInRect(position.x, position.y, objectWidth, objectHeight, "DEFGLPRST");
  }
}
