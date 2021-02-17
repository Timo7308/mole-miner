final String gameOverMessage = "game over";
final String wonMessage = "you won";
final String startMessage = "press <space> to start";
final String introductionMessage = "collect as much gold as you can\nwatch out for deep holes";
final String goldMessageSuffix = " gold";

PFont defaultFont;
PImage treausureImg;

final int STARTED = 0, RUNNING = 1, LOST = 2, WON = 3;
int gameState = STARTED;

Map map;
Player player;
int goldCount;

void setup() {
  size(600, 750); 
  defaultFont = createFont("FiraCode-Bold.ttf", 28);
  textFont(defaultFont);
  treausureImg = loadImage("images/T.png");
  
  map = new Map("level_01.map");
}

void startGame() {
  map = new Map("level_01.map");
  player = new Player(100, 159);
  goldCount = 0;
  gameState = RUNNING;
}

void keyPressed() {
  if (gameState == STARTED || gameState == LOST || gameState == WON) {
    if (key == ' ') {
      startGame();
    }
  } else if (gameState == RUNNING) {
    if (keyCode == RIGHT) {
      player.moveRight();
    } else if (keyCode == LEFT) {
      player.moveLeft();
    } else if (keyCode == DOWN) {
      player.dig();
    }
  }
}

void keyReleased() {
  if (gameState == RUNNING) {
    player.stop();
  }
}

void draw() {
  background(0);

  if (gameState == STARTED) {
    map.draw(0, 0);
    fill(0, 150);
    rect(0, 0, width, height);
    fill(255);
    textAlign(CENTER);
    text(startMessage + "\n" + introductionMessage, width/2, height/2);
  } else if (gameState == RUNNING) {
    map.draw(0, 0);
    player.draw();
    fill(255);
    textAlign(RIGHT);
    text(goldCount + goldMessageSuffix, width-10, 40);
  } else if (gameState == LOST) {
    fill(255);
    textAlign(CENTER);
    text(gameOverMessage + "\n" + startMessage, width/2, height/2);
    chaoticFilter();
  } else if (gameState == WON) {
    fill(255);
    textAlign(CENTER);
    text(wonMessage + "\n" + goldCount + goldMessageSuffix + "\n" + startMessage, width/2, height/2);
    image(treausureImg, width/2-25, height/2-140);
  }
}

void chaoticFilter() {
  loadPixels();
  
  int m = millis();
  
  for (int i = 0; i < 100; i++) {
    //int xStart = (int)random(width/50)*50;
    //int yStart = (int)random(height/50)*50;
    //int xTarget = (int)random(width/50)*50;
    //int yTarget = (int)random(height/50)*50;
    int xStart = (int)(noise(m)*width);
    int yStart = (int)(noise(m+i)*height);
    int xTarget = (int)(noise(m+i)*width);
    int yTarget = (int)(noise(m+2*i)*height);
    
    for (int x = 0; x < 50; x++) {
      for (int y = 0; y < 50; y++) {
        int index = xStart+x + (yStart+y)*width;
        int targetIndex = xTarget+x + (yTarget+y)*width;
        color value = pixels[index];
        color targetValue = pixels[targetIndex];
        color newValue = color(red(targetValue)*0.5+red(value)*0.3, green(targetValue)*0.5+green(value)*0.3, blue(targetValue)*0.5+blue(value)*0.3);
        pixels[targetIndex] = newValue;
      }
    }
  }
  
  updatePixels();
}
