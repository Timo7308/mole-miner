final String gameOverMessage = "Game over";
final String wonMessage = "Gewonnen!";
final String restartMessage = "Drücke die <Leertaste> zum Starten";
final String introductionMessage = "Sammle so viel Gold wie du kannst,\n aber halte dich von tiefen Löchern fern";
final String goldMessageSuffix = " Gold";

boolean button = false; 

PFont defaultFont;
PImage treausureImg, houseImg;

final int STARTED = 0, RUNNING = 1, LOST = 2, WON = 3;
int gameState = STARTED;

Map map;
Player player;
int goldCount;
int mapY;
FallingTileFilter fallingTileFilter;

void setup() {
  size(600, 750); 
  defaultFont = createFont("FiraCode-Bold.ttf", 28);
  textFont(defaultFont);
  treausureImg = loadImage("images/T.png");
  houseImg = loadImage("images/house.png");
  map = new Map("level_01.map");
}

void startGame() {
  map = new Map("level_01.map");
  player = new Player(100, 159);
  goldCount = 0;
  mapY = 0;
  fallingTileFilter = new FallingTileFilter();
  gameState = RUNNING;
}

void keyPressed() {
  if (gameState == LOST || gameState == WON) {
    if (key == ' ') {
      startGame();
    }
  } else if (gameState == RUNNING) {
    if (keyCode == RIGHT) {
      player.moveRight();
    } else if (keyCode == LEFT) {
      player.moveLeft();
    } else if (keyCode == DOWN) {
      player.moveDown();
    } else if (keyCode == UP) {
      player.moveUp();
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
    image(houseImg, 370, 46, 180, 180);
    rect(0, 0, width, height);
    fill(255);
    textAlign(CENTER);
    textSize(15);
    text(introductionMessage, width/2, height/2-70);

    textSize(55);
    text("Mole Miner", 297, height/2 -200);

    fill(#FFD700);
    strokeWeight(2);
    rect(222, height/2+34, 152, 55);
    fill(0);
    textSize(25);
    text("Starten", 297, height/2+70);


    // Steuerung
    fill(#FFD700);
    rect(10, height/2+245, 200, 125);
    fill(0);
    textSize(14);
    text("Steuerung:", 60, height/2+264);

    // Pfeiltasten und Text
    fill(255);
    rect(98, height/2+291, 20, 20);
    rect(98, height/2+317, 20, 20);
    rect(73, height/2+317, 20, 20);
    rect(124, height/2+317, 20, 20);
    textSize(13);
    fill(0);
    text("↑", 108, height/2+305);
    text("->", 135, height/2+331);
    text("<-", 83, height/2+331);
    text("↓", 108, height/2+332);
    line(108, height/2+278, 108, height/2+287);
    line(118, height/2+277, 108, height/2+277);
    line(150, height/2+327, 160, height/2+327);
    line(67, height/2+327, 58, height/2+327);
    line(108, height/2+352, 108, height/2+343);
    textSize(10);
    text("oben", 142, height/2+281);
    text("rechts", 185, height/2+331);
    text("links", 37, height/2+330);
    text("unten", 122, height/2+363);
  } else if (gameState == RUNNING) {
    map.draw(0, 0);
    player.draw();
    fill(255);
    textAlign(RIGHT);
    textSize(25);
    text(goldCount + goldMessageSuffix, width-10, 40);
    image(houseImg, 370, 46, 180, 180);
  } else if (gameState == LOST) {
    if (mapY < height) {
      mapY += 1000 / frameRate;
      map.draw(0, mapY);
      fallingTileFilter.apply();
    }
    
    player.draw();
    
    fill(255);
    textAlign(CENTER);
    text(gameOverMessage + "\n" + restartMessage, width/2, height/2);
    
  } else if (gameState == WON) {
    fill(255);
    textAlign(CENTER);
    text(wonMessage + "\n" + goldCount + goldMessageSuffix + "\n" + restartMessage, width/2, height/2);
    image(treausureImg, width/2-25, height/2-140);
  }
}

void mousePressed() {
  // Koordinaten des Startbuttons
  if (mouseX>222 && mouseX < 222 + 152 && mouseY >409 && mouseY < 409 + 55) {
    button = true;
  }
  if (button && gameState == STARTED) {
    startGame();
  }
}
