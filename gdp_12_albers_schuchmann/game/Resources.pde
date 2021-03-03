/**
 * Holds references to static resources like images and sounds.
 */
class Resources {
  PImage mole = loadImage("images/mole.png");
  PImage skeletonLeft = loadImage("images/skeleton-left.png");
  PImage skeletonRight = loadImage("images/skeleton-right.png");
  PImage bat = loadImage("images/bat.png");
  
  SoundFile mainTheme01;
  SoundFile mainTheme02;
  SoundFile goldCollected;
  SoundFile diamantCollected;
  SoundFile won;
  SoundFile lost;

  /**
   * Creates a new instance.
   *
   * @param parent the parent used for sound files, usually `this`
   */
  Resources(PApplet parent) {
    mainTheme01 = new SoundFile(parent, "sounds/main-theme-01.mp3");
    mainTheme02 = new SoundFile(parent, "sounds/main-theme-02.mp3");
    goldCollected = new SoundFile(parent, "sounds/gold-collected.mp3");
    diamantCollected = new SoundFile(parent, "sounds/diamant-collected.mp3");
    won = new SoundFile(parent, "sounds/won.mp3");
    lost = new SoundFile(parent, "sounds/lost.mp3");
  }
}
