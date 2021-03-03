/**
 * Represents the player.
 */
class Player extends MovingObject {
  final static private int size = 40;
  
  private PImage img = resources.mole;
  
  private DirtParticle[] dirtParticles = new DirtParticle[30];
  private int dirtParticleIndex = 0;
  private ArrayList<DirtHole> dirtHoles = new ArrayList<DirtHole>();
  
  /**
   * Creates a new player with the given position.
   *
   * @param x the x coordinate of the position
   * @param y the y coordinate of the position
   */
  Player(float x, float y) {
    super(size, size, new PVector(x, y));
  }
  
  /**
   * Stops the movement of the player.
   */
  void stop() {
    velocity.x = 0;
    
    if (isDigging()) {
      velocity.y = 0;
    }
  }
  
  /**
   * Starts moving the player to the right.
   */
  void moveRight() {
    velocity.x = 200;
  }
  
  /**
   * Starts moving the player to the left.
   */
  void moveLeft() {
    velocity.x = -200;
  }
  
  /**
   * Starts moving the player down.
   */
  void moveDown() {
    velocity.y = 80;
  }
  
  /**
   * Starts moving the player up.
   */
  void moveUp() {
    velocity.y = -60;
  }
  
  /**
   * Draws the player.
   */
  void draw() {
    updatePosition();

    for (DirtParticle dirtParticle : dirtParticles) {
      if (dirtParticle == null) continue;
      dirtParticle.draw();
    }
    
    for (DirtHole dirtHole : dirtHoles) {
      dirtHole.draw();
    }
    
    image(img, position.x, position.y, size, size);
  }
  
  /**
   * Update the player's position and detect hit's with other objects.
   */
  protected void updatePosition() {
    super.updatePosition();
    
    Map.TileReference currentTile = getCurrentTile();
    
    if (currentTile == null) {
      println("warning: unable to obtain current tile");
      return;
    }

    if (currentTile.tile == 'P') {
       map = new Map("level_02.map");
       player = new Player(300, 359);
       return;
    }
    
    if (currentTile.tile == 'T') {
      changeState(WON);
      return;
    }
    
    if (velocity.y > 700 || position.y > height) {
      stop();
      changeState(LOST);
      return;
    }
    
    for (Opponent opponent : opponents) {
      if (collidesWith(opponent)) {
        stop();
        changeState(LOST);
        return;
      }
    }
    
    if (currentTile.tile == 'G') {
      goldCount++;
      map.set(currentTile.x, currentTile.y, 'D');
      resources.goldCollected.play();
    } else if (currentTile.tile == 'F') {
      diamondCount++;
      map.set(currentTile.x, currentTile.y, 'D');
      resources.diamantCollected.play();
    }
    
    if (isDigging()) {
      addDirtParticle();
      
      if ("DG".indexOf(currentTile.tile) != -1 && random(100) > 60) {
        addDirtHole(currentTile);
      }
      
    }
  }
  
  /**
   * Adds a particle of dirt when digging.
   */
  protected void addDirtParticle() {
    dirtParticles[dirtParticleIndex++] = new DirtParticle(new PVector(position.x + objectWidth/2, position.y + objectHeight/2));
    if (dirtParticleIndex >= dirtParticles.length) dirtParticleIndex = 0;
  }
  
  /**
   * Adds a hole to the dirt the player is digging through.
   */
  protected void addDirtHole(Map.TileReference tile) {
    dirtHoles.add(new DirtHole(tile));
  }
  
  /**
   * Returns whether the player is currently digging.
   *
   * @return true, if the player is currently digging
   */
  private boolean isDigging() {
    Map.TileReference currentTile = getCurrentTile();
    boolean isDiggingInDirt = (velocity.x != 0 || velocity.y != 0) && "DGT".indexOf(currentTile.tile) != -1;
    boolean isDiggingThroughLawn = velocity.y > 0 && currentTile.tile == 'L';
    return isDiggingInDirt || isDiggingThroughLawn;
  }
}
