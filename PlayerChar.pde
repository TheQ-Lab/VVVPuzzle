class PlayerChar extends MovableEntity { //<>//

  int txW, txH;
  char facing = 'r', looking = '0';//facing r,l; looking 0,u,d
  float walkSpeedCap, fallSpeedCap;
  float walkAcceleration, walkDecceleration, maxJumpAcceleration, jumpAcceleration, gravity;
  PImage projectile_texture;
  PImage texture_walk, texture_rise, texture_fall;

  boolean rightPressed, leftPressed, upPressed, downPressed, jumpPressed = false, shootPressed = false;



  PlayerChar(float x, float y, int w, int h, char semisolid, int txW, int txH) {
    super(x, y, w, h, semisolid);
    this.semisolid ='0';
    this.txW = txW;
    this.txH = txH;

    walkAcceleration = 0.23;
    walkDecceleration = 0.38;
    walkSpeedCap = 5;
    gravity = 0.45;
    maxJumpAcceleration = -2;
    jumpAcceleration = maxJumpAcceleration;
    fallSpeedCap = 15;

    this.col = color(255, 209, 220);
    
    texture_walk = loadImage("assets/character/feufeu_walk.png");
    texture_rise = loadImage("assets/character/feufeu_rise.png");
    texture_fall = loadImage("assets/character/feufeu_fall.png");
    
    projectile_texture = loadImage("assets/character/feufeu_projectile.png");
  }

  void assignTexture (PImage newTexture) {
    if (newTexture!=null) texture = newTexture;
  }

  @Override
    void move() {
    calculateNewTheoreticalPos();
    /*for (Entity o2 : entities) {
     checkAllCollisionTypesWith(o2);
     }*/
    for (int i = entities.size() - 1; i >= 0; i --) {
      Entity o2 = entities.get(i); //wenn bei lvl4 goal nextLevel = 1 --> index out of bounds error
      checkAllCollisionTypesWith(o2);
    }

    x = newX;
    y = newY;
    calculateSpeeds();
    //update parameters
    if (grounded) jumpReset();
    if (!checkStillGrounded()) { 
      grounded = false;
      groundedOn = null;
    }
  }

  void calculateNewTheoreticalPos() {
    newX = x+hSpeed;
    newY = y+vSpeed;
  }


  float[] checkAllCollisionTypesWith(Entity o2) {
    char ss = o2.semisolid;
    if (ss == 't') { //if o2 is for example Trigger
      if (x>=o2.x&&x<=o2.x+o2.w || x+w>=o2.x&&x+w<=o2.x+o2.w) {
        //check if in same Y-Space
        if (y>=o2.y&&y<=o2.y+o2.h || y+h>=o2.y&&y+h<=o2.y+o2.h) {
          o2.hit();
        }
      } else {
        o2.noHit();
      }
    } else {
      if (vSpeed > 0) {
        //while arrayList of Entities != null, if a collision is found (-1), break
        if (ss == '0'||ss == 'u') {
          float collY = checkBottomCollision(this, o2);
          if (collY >= 0) {
            newY = collY;
            grounded = true;
            groundedOn = o2;
          }
        }
      } else if (vSpeed < 0) {
        if (ss == '0'||ss == 'd') {
          float collY = checkTopCollision(this, o2);
          if (collY >= 0) {
            newY = collY;
            grounded = true;
            groundedOn = o2;
          }
        }
      }
      if (hSpeed > 0) {
        if (ss == '0'||ss == 'l') {
          float collX = checkRightCollision(this, o2);
          if (collX >= 0) newX = collX;
        }
      } else if (hSpeed < 0) {
        if (ss == '0'||ss == 'r') {
          float collX = checkLeftCollision(this, o2);
          if (collX >= 0) newX = collX;
        }
      }
    }
    float[] response = {newX, newY}; 
    return response;
  }
  //<>//
  @Override
    void display() {
    //seems render less chuggy when named draw instead of display  
    if (texture==null) {
      stroke(255);
      strokeWeight(2);
      fill(col);
      rect(x, y, (float)w, (float)h);
    }
    if (texture!=null) {
      int txYOffset = h-txH;
      if (facing=='r') {
        if (vSpeed < 0) { //rise
          image(texture_rise, x, y+txYOffset, txW, txH);
        } else if (vSpeed > 0+0.55f) { //fall
          image(texture_fall, x, y+txYOffset, txW, txH);
        } else if (hSpeed != 0) { //walk
          image(texture_walk, x, y+txYOffset, txW, txH);
        } else {
          image(texture, x, y+txYOffset, txW, txH);
        }
        
      } else if (facing=='l') {
        pushMatrix();
        translate(x+w, y);
        scale(-1, 1);

        if (vSpeed < 0) { //rise
          image(texture_rise, 0, txYOffset, txW, txH);
        } else if (vSpeed > 0+0.55f) { //fall
          image(texture_fall, 0, txYOffset, txW, txH);
        } else if (hSpeed != 0) { //walk
          image(texture_walk, 0, txYOffset, txW, txH);
        } else {
          image(texture, 0, txYOffset, txW, txH);
        }
        
        popMatrix();
      }
    }
  }


  void calculateSpeeds() {//update Speeds and Inputs

    //update horizontal speed (w/ userInputs)
    if (rightPressed&&!leftPressed) {
      rightPressed();
    } else if (leftPressed&&!rightPressed) {
      leftPressed();
    } else {
      if (grounded && hSpeed != 0) {
        deccelerate();
      }
    }

    if (upPressed && !downPressed) {
      looking = 'u';
    } else if (downPressed && !upPressed) {
      looking = 'd';
    } else {
      looking = '0';
    }


    if (jumpPressed) {
      jumpPressed();
    }
    //no else because Gravity is always
    if (!grounded) applyGravity();
    if (grounded) vSpeed = 0;

    //no shoot, because its no continous task but once per press
  }

  void deccelerate() {
    if ((hSpeed -= walkDecceleration) >= 0) {
      hSpeed -= walkDecceleration;
    } else if ((hSpeed += walkDecceleration) <= 0) {
      hSpeed += walkDecceleration;
    } else {
      hSpeed = 0;
    }
  }


  void rightPressed() {
    if (hSpeed < 0) { 
      deccelerate();
    }
    hSpeed += walkAcceleration;
    if (hSpeed>walkSpeedCap) { 
      hSpeed = walkSpeedCap;
    }
    facing = 'r';
  }
  void leftPressed() {
    if (hSpeed > 0) { 
      deccelerate();
    }
    hSpeed -= walkAcceleration;
    if (hSpeed<-walkSpeedCap) { 
      hSpeed = -walkSpeedCap;
    }
    facing = 'l';
  }

  void jumpPressed() {
    grounded = false;
    groundedOn = null;
    vSpeed += jumpAcceleration;
    //deccelerate jump speed when jump is held down
    if (jumpAcceleration<0) {
      jumpAcceleration /= 1.21;
    }
  }

  void shootPressed() {
    if (!shootPressed) {
      char projDirection;
      if (looking == '0') {
        projDirection = facing;
      } else {
        projDirection = looking;
      }
      Projectile p = new Projectile(x+(w/4), y, 35, 20, projDirection); //or textureNewProjectile.w and textureNewProjectile.h
      p.assignTexture(projectile_texture);
      projectiles.add(p);
      shootPressed = true;
    }
  }
  void shootReleased() { 
    shootPressed = false;
  }

  void jumpReset() {
    jumpAcceleration = maxJumpAcceleration;
  }

  void applyGravity() {
    if (vSpeed <= fallSpeedCap) vSpeed += gravity;
  }

  boolean checkStillGrounded() {
    //if Gravity reversed make abfrage for Objs gravity direction and reverse accordingly
    if (grounded) {
      if ((int(groundedOn.y)) != this.y+this.h) {
        //If plattform is not exactly under it any more (by char jumping or plattform moving down)
        return false;
      }
      if (!(this.x >= groundedOn.x && this.x <= groundedOn.x+groundedOn.w -1  ||  groundedOn.x >= this.x && groundedOn.x <= this.x+this.w -1)) {
        //or if slid off sideways off the plattform
        return false;
      }
      //else it is still grounded (true)
      return true;
    }
    //if it isnt grounded in the first place, it is not grounded
    return false;
  }

  void teleport(float x2, float y2) {
    println("port to " + x2 + " " + y2);
    x = x2;
    y = y2;
    newX = x2;
    newY = y2;
    vSpeed = 0;
    hSpeed = 0;
  }

  void die() {
    println("Herzlichen Glückwunsch! Du bist soeben gestorben!");
    appMgr.addTask("loadLevel:");
    appMgr.addTask(str(level.levelNumber));
  }
}
