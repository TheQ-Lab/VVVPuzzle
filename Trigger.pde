class Trigger extends Entity {
  
  //https://stackoverflow.com/questions/38980395/processing-load-and-play-sound
  boolean alreadyHit = false;
  
  
  Trigger(float x, float y, int w, int h, char semisolid) {
    super(x, y, w, h, semisolid);
  }
  
  
  @Override
  void display(){
    if (texture==null) {
      stroke(255);
      strokeWeight(0);
      fill(col);
      rect(x,y,(float)w,(float)h);
    } else {
      image(texture,x,y);
    }
    
  }
  
  void hit() {
    
  }
  
  void noHit() {
    
  }
  
}

class Goal extends Trigger {
  //Goal-specific
  int nextLevel;
  Goal (float x, float y, int w, int h, char semisolid, int nextLevel){
    super(x, y, w, h, semisolid);
    semisolid = 't';
    col = color(80,0,0);
    this.nextLevel = nextLevel;
  }
  
  @Override
  void hit() {
    if (!alreadyHit) {
      col = color(0,130,0);

      playSfx();
      restartBgm();
      
      alreadyHit = true;
      
      appMgr.addTask("loadLevel:");
      appMgr.addTask(str(nextLevel));
    }
  }
  
  @Override
  void noHit() {
    col = color(80,0,0);
    alreadyHit = false;
  }
  
}

class Teleport extends Trigger {
  //Teleport-specific
  float x2,y2;
  float angAnim = 0f;
  Teleport (float x, float y, int w, int h, char semisolid, float x2, float y2){
    super(x, y, w, h, semisolid);
    semisolid = 't';
    col = color(80,0,0);
    this.x2 = x2;
    this.y2 = y2;
    //musicItemGet = new SoundFile(VVVPuzzle_02.this, "music/Special Item Get.wav");
  }
  
  @Override
  void hit() {
    if (!alreadyHit) {
        character.teleport(x2,y2);
        alreadyHit = true;
    }
  }
  
  @Override
  void noHit() {
    alreadyHit = false;
  }
  
  @Override
  void display() {
    if (texture==null) {
      stroke(255);
      strokeWeight(0);
      fill(col);
      rect(x,y,(float)w,(float)h);
    } else {
      pushMatrix();
      translate(x+(w/2),y+(h/2));
      angAnim += PI/60;
      rotate(angAnim);
      translate(-(w/2),-(h/2));
      tint(255,170);
      image(texture,0,0,w,h);
      tint(255,255);
      popMatrix();
    }
  }
  
  
}
