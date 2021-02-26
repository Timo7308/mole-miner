class Player extends MovingObject {
  final static private int size = 40;
  
  private PImage img;
  
  private DirtParticle[] dirtParticles = new DirtParticle[60];
  private int dirtParticleIndex = 0;
  private ArrayList<DirtHole> dirtHoles = new ArrayList<DirtHole>();
  
  Player(float x, float y) {
    super(size, size, new PVector(x, y));
    this.img = loadImage("images/mole.png");
  }
  
  void stop() {
    velocity.x = 0;
    
    if (isDigging()) {
      velocity.y = 0;
    }
  }
  
  void moveRight() {
    velocity.x = 200;
  }
  
  void moveLeft() {
    velocity.x = -200;
  }
  
  void moveDown() {
    velocity.y = 80;
  }
  
  void moveUp() {
    velocity.y = -60;
  }
  
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
  
  protected void updatePosition() {
    super.updatePosition();
    
    Map.TileReference currentTile = getCurrentTile();
    
    if (currentTile == null) {
      println("warning: unable to obtain current tile");
      return;
    }
    
    if (currentTile.tile == 'T') {
      gameState = WON;
      return;
    }
    
    if (velocity.y > 700 || position.y > height) {
      stop();
      gameState = LOST;
      return;
    }
    
    if (collidesWith(bat)) {
      stop();
      gameState = LOST;
      return;
    }
    
    if (currentTile.tile == 'G') {
      goldCount++;
      map.set(currentTile.x, currentTile.y, 'D');
    } else if (currentTile.tile == 'F') {
      diamondCount++;
      map.set(currentTile.x, currentTile.y, 'D');
    }
    
    if (isDigging()) {
      addDirtParticle();
      
      if ("DG".indexOf(currentTile.tile) != -1 && random(100) > 60) {
        addDirtHole(currentTile);
      }
      
    }
  }
  
  protected void addDirtParticle() {
    dirtParticles[dirtParticleIndex++] = new DirtParticle(new PVector(position.x + objectWidth/2, position.y + objectHeight/2));
    if (dirtParticleIndex >= dirtParticles.length) dirtParticleIndex = 0;
  }
  
  protected void addDirtHole(Map.TileReference tile) {
    dirtHoles.add(new DirtHole(tile));
  }
  
  private boolean isDigging() {
    Map.TileReference currentTile = getCurrentTile();
    boolean isDiggingInDirt = (velocity.x != 0 || velocity.y != 0) && "DGT".indexOf(currentTile.tile) != -1;
    boolean isDiggingThroughLawn = velocity.y > 0 && currentTile.tile == 'L';
    return isDiggingInDirt || isDiggingThroughLawn;
  }
}
