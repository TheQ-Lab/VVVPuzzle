class FloatBlock extends MovableEntity {

  boolean splitUp;
  PImage texture_b;

  FloatBlock(float x, float y, int w, int h, char semisolid, char gravityDirection) {
    super(x, y, w, h, semisolid);
    if (gravityDirection == 'u') { 
      splitUp = true;
    } else if (gravityDirection == 'd') { 
      splitUp = false;
    }
    newY = y; newX = x;
    
    vSpeed = 2.5;
  }
  
  void assignTexture(PImage newTexture_a, PImage newTexture_b) {
    if (newTexture_a!=null) texture = newTexture_a;
    if (newTexture_b!=null) texture_b = newTexture_b;
  }

  @Override
  void move() {
    if (!grounded) {
      //println("flying FB" + millis());
      if (splitUp) {
        newY = y-vSpeed;
        for (Entity o2 : entities) {
          if (this != o2) {
            float collY = checkTopCollision(this,o2);
            if (collY >= 0) {
              newY = collY;
              grounded = true;
              groundedOn = o2;
            }
          }
        }
      } else {
        newY = y+vSpeed;
        for (Entity o2 : entities) {
          if (this != o2) {
            float collY = checkBottomCollision(this,o2);
            if (collY >= 0) {
              newY = collY;
              grounded = true;
              groundedOn = o2;
            }
          }
        }
      }
      if (!splitUp){
        float collY = checkBottomCollision(this,character);
        if (collY >= 0) {
          //println("unten Collision");
          character.newY = this.newY+this.h;
          for (int i = entities.size() - 1; i >= 0; i --){
            Entity o2 = entities.get(i);
            if (this != o2) {
              float characterCollY = checkBottomCollision(character,o2);
              if (characterCollY >= 0) {
                character.die();
              }
            }
          }
          character.y = character.newY;
        }
      } else if (splitUp) {
        float collY = checkTopCollision(this,character);
        if (collY >= 0) {
          //println("oben Collision");
          character.newY = this.newY-character.h;
          for (int i = entities.size() - 1; i >= 0; i --){
            Entity o2 = entities.get(i);
            if (this != o2) {
              float characterCollY = checkTopCollision(character,o2);
              if (characterCollY >= 0) {
                character.die();
              }
            }
          }
          character.y = character.newY;
        }
      }
      y = newY;
    }
    //comment this out & set grounded = true upon Object creation to let it hover until being shot for the 1st time
    if (grounded) checkStillGrounded();
    
    if (!grounded) {
      /*
      if (x>character.x&&x<character.x+character.w || x+w>character.x&&x+w<character.x+character.w) {
        //check if in same Y-Space
        if (y>=character.y&&y<=character.y+character.h || y+h>=character.y&&y+h<=character.y+character.h) {
          //println("tot"+millis());
          println("character.x:"+character.x + "FBx:" + x + "FBw:" + w);
          //SCHIeben, nicht töten, brauche aber auch Richtung 
        }
      }
      */
      
    }
  }

 
  @Override
  void display() {
    if (texture==null) {
      stroke(255);
      strokeWeight(2);
      fill(col);
      rect(x,y,(float)w,(float)h);
    }
    else if (texture!=null) {
      if (!splitUp) image(texture,x,y,w,h);
      else if (splitUp) image(texture_b,x,y,w,h);
    } 
    
    if (debugMode) {
      noFill();
      strokeWeight(4);
      if (!splitUp) {
        stroke(250,40,40);
      } else if (splitUp) {
        stroke(40,250,40);
      }
      rect(x,y,w,h);
      
      debugShowSemisolid();
    }
  }

  @Override
  void hit() {
    super.hit();
    grounded = false;
    splitUp = !splitUp;
  }

  void checkStillGrounded() {
    if (!splitUp) {
      if (groundedOn.y != y+h) {
        grounded = false;
        groundedOn = null;
      }
    } else if (splitUp) {
      if (groundedOn.y+groundedOn.h != y) {
        grounded = false;
        groundedOn = null;
        print(" yo");
      }
    }
  }
}
