final int levelNo = 8;
boolean debugMode = false;




String sketchName = "VVVPuzzle_02";
int charX, charY;
PlayerChar character;
ArrayList<Entity> entities;

//Entity floor;
AppMgr appMgr;
Level level;
ArrayList<Projectile> projectiles;
Test test;
static int h;
static int w;



void setup(){
  //surface.setLocation(100, 100);
  test = new Test();
  appMgr = new AppMgr();
  
  PImage tx_player= loadImage("assets/character/feufeu.png");
  size(1280, 720);
  frameRate(60); //<>//
  
  setupMusic();
  
  entities = new ArrayList<Entity>();
  //floor = new Entity(0,700,1280,20,'u');
  //entities.add(floor);
  projectiles = new ArrayList<Projectile>();
  //level = new Level(levelNo);
  
  
  character = new PlayerChar(20.0,625, 50, 30, '0', 60, 74);//collider Size - txSize
  //Ghosty: w: 42, h: 50, txW: 62, txH: 50;
  //Moon:   w: 50, h: 50, txW: 50, txH: 50;
  //Feufeu: w: 50, h: 50, txW: 50, txH: 74; (/23,64 = Skalierungsfaktor)
  //Slimey: w: 50, h: 50, txW: 50, txH: 66; (/20,36)
  
  character.assignTexture(tx_player);
  
  level = new Level(levelNo);
  
  
  
  //Variables innately to the game
  h = height;
  w = width;
  
  
  
}

void draw(){
  if (level.levelNumber > 4) {
    image(level.bg,0,0); //<>//
  } else if (level.levelNumber == 1) {
    image(level.bg_tut_1,0,0);
  } else if (level.levelNumber == 2) {
    image(level.bg_tut_2,0,0);
  } else if (level.levelNumber == 3) {
    image(level.bg_tut_3,0,0);
  } else if (level.levelNumber == 4) {
    image(level.bg_tut_4,0,0);
  }

  //for all FloatBlocks.move
  for (Entity o : entities) {
    /*for (Entity p : entities) {
      if (o == p) {
        numFloatBl++;
      }
    }*/
    if (o instanceof FloatBlock) {
      o.move();
    }
  }
  //println(numFloatBl);
  
  character.move();
  for (Projectile p : projectiles) {
    p.move();
    p.collision();
    p.checkDespawn();
  }
  
  character.display();
  for (Entity o : entities) {
    o.display();
  }
  
  // If you are modifying an ArrayList during the loop,
  // then you cannot use the enhanced loop syntax.
  // In addition, when deleting in order to hit all elements, 
  // you should loop through it backwards, as shown here:
  for (int i = projectiles.size() - 1; i >= 0; i --){
    Projectile p = projectiles.get(i);
    if(p.willDespawn){
      projectiles.remove(p);
      continue;
    }
    p.display();
  }
  
  
  postProcessing();
  
  test.testLoop();
  appMgr.loop();
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT){
      character.rightPressed = true;
    }
    if (keyCode == LEFT){
      character.leftPressed = true;
    }
    if (keyCode == UP){
      character.upPressed = true;
    }
    if (keyCode == DOWN){
      character.downPressed = true;
    }
  }
  if (key == 'y' || key == 'z' || key == 'a') {
    //CONSOLE
    //println("JUMP");
    if (character.grounded) {
      //CONSOLE
      //println("JUMP execute");
      character.jumpPressed = true;
    } 
  }
  if (key == 'x' || key == 's') {
    character.shootPressed();
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == RIGHT){
      character.rightPressed = false;
    }
    if (keyCode == LEFT){
      character.leftPressed = false;
    }
    if (keyCode == UP){
      character.upPressed = false;
    }
    if (keyCode == DOWN){
      character.downPressed = false;
    }
  }
  if (key == 'y' || key == 'z' || key == 'a') {
    character.jumpPressed = false;
    //CONSOLE
    //println("released (jump)");
  }
  if (key == 'x' || key == 's') {
    character.shootReleased();
  }
  if (key == 'd') {
    debugMode = !debugMode; 
  }
}
