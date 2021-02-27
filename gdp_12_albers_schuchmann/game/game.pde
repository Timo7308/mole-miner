import processing.sound.*;

final String gameOverMessage = "Game over";
final String wonMessage = "Gewonnen!";
final String restartMessage = "Drücke die <Leertaste> zum Starten";
final String introductionMessage = "Sammle so viel Gold und Diamanten wie du kannst,\n aber halte dich von tiefen Löchern, Fledermäusen \n und Skeletten fern";
final String goldMessageSuffix = "Gold: ";
final String diamondMessageSuffix = "Diamanten: ";

PFont defaultFont;
PImage treausureImg, houseImg;

SoundFile mainTheme01;
SoundFile mainTheme02;
SoundFile mainTheme03;

FallingTileFilter fallingTileFilter;

final int STARTED = 0, RUNNING = 1, LOST = 2, WON = 3;
int gameState = STARTED;

int gameStartedTime;
int nextBatTime;

Map map;
int mapY;

int goldCount;
int diamondCount;

Player player;
ArrayList<Opponent> opponents;

void setup() {
  size(600, 750); 
  defaultFont = createFont("FiraCode-Bold.ttf", 28);
  textFont(defaultFont);
  treausureImg = loadImage("images/T.png");
  houseImg = loadImage("images/house.png");
  map = new Map("level_01.map");

  fallingTileFilter = new FallingTileFilter();

  mainTheme01 = new SoundFile(this, "main-theme-01.mp3");
  mainTheme02 = new SoundFile(this, "main-theme-02.mp3");

  mainTheme01.loop();
}

void startGame() {
  map = new Map("level_01.map");
  player = new Player(100, 159);
  opponents = new ArrayList<Opponent>();

  goldCount = 0;
  diamondCount = 0;
  mapY = 0;

  mainTheme01.stop();
  mainTheme02.loop();
  gameStartedTime = millis();
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
    image(houseImg, 370, 42, 180, 180);
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
    updateObjects();

    map.draw(0, 0);
    player.draw();

    for (Opponent opponent : opponents) opponent.draw();

    fill(255);
    textAlign(RIGHT);
    textSize(25);
    text(goldMessageSuffix + goldCount, width-10, 40);
    textSize(20);
    text(diamondMessageSuffix + diamondCount, width-10, 70);
    image(houseImg, 370, 42, 180, 180);
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
    text(wonMessage + "\n"+"\n" + goldMessageSuffix + goldCount + "\n"  + diamondMessageSuffix + diamondCount + "\n" + "\n" +"\n" + restartMessage, width/2, height/2);
    image(treausureImg, width/2-25, height/2-140);
  }
}

void mousePressed() {
  // Koordinaten des Startbuttons
  boolean startButtonPressed = mouseX > 222 && mouseX < 222 + 152 && mouseY > 409 && mouseY < 409 + 55;
  if (startButtonPressed && gameState == STARTED) {
    startGame();
  }
}

void updateObjects() {
  int currentTime = millis();

  if (nextBatTime < gameStartedTime) scheduleNewBat();

  if (nextBatTime <= currentTime) {
    spawnNewBat();
    scheduleNewBat();
  }
}

void spawnNewBat() {
  // Obtain the position of all dirt tiles
  ArrayList<PVector> dirtTiles = getPositionsOfTilesWithType('D');

  // Select a random dirt tile in the first three quartes of all dirt tiles.
  // This prevents opponents from spawning in the lower part of the window,
  // which would make the game too hard.
  int randomDirtTileIndex = (int)random(dirtTiles.size()/4*3); 
  PVector randomDirtTile = dirtTiles.get(randomDirtTileIndex);

  int margin = (map.tileSize - Opponent.size) / 2;

  Opponent o = fiftyFifty()
    ? new Bat(randomDirtTile.x+margin, randomDirtTile.y+margin)
    : new Skeleton(randomDirtTile.x+margin, randomDirtTile.y+margin);
  opponents.add(o);

  // Remove opponents if there are too many
  while (opponents.size() > 2) {
    opponents.remove(0);
  }
}

void scheduleNewBat() {
  nextBatTime = millis() + (int)random(3000, 6000);
}

ArrayList<PVector> getPositionsOfTilesWithType(char type) {
  ArrayList<PVector> tiles = new ArrayList<PVector>();

  for (int y = 0; y < map.map.length; y++) {
    String row = map.map[y];

    for (int x = 0; x < row.length(); x++) {
      char tile = row.charAt(x);

      if (tile == 'D') {
        tiles.add(new PVector(x * map.tileSize, y * map.tileSize));
      }
    }
  }

  return tiles;
}

boolean fiftyFifty() {
  return random(1) >= 0.5;
}
