class FallingTileFilter {
  private final int CHAOTIC_FILTER_ELEMENT_COUNT = 50;
  private PVector[] chaoticFilterStartPositions = new PVector[CHAOTIC_FILTER_ELEMENT_COUNT];
  private PVector[] chaoticFilterTargetPositions = new PVector[CHAOTIC_FILTER_ELEMENT_COUNT];

  FallingTileFilter() {
    for (int i = 0; i < chaoticFilterStartPositions.length; i++) {
      chaoticFilterStartPositions[i] = new PVector(random(width-50), random(height-50));
    }
    
    for (int i = 0; i < chaoticFilterTargetPositions.length; i++) {
      chaoticFilterTargetPositions[i] = new PVector(random(width-50), random(height-50));
    }
  }
  
  void apply() {
    loadPixels();
    
    int size = map.tileSize;
    
    for (int i = 0; i < chaoticFilterStartPositions.length; i++) {
      PVector start = chaoticFilterStartPositions[i];
      PVector target = chaoticFilterTargetPositions[i];

      for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
          int index = (int)(start.x+x + (start.y+y)*width);
          int targetIndex = (int)(target.x+x + (target.y+y)*width);
          
          color value = pixels[index];
          pixels[targetIndex] = value;
        }
      }
    }
  
    updatePixels();
  }
}
