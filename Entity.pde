class Entity {
  float x, y;
  int w, h;
  color col = color(100,100,100);
  char semisolid; //u,d,l,r
  PImage texture;
  
  
  Entity (float x, float y, int w, int h, char semisolid){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.semisolid = semisolid;
    /*if (tx_src != null) {
      //println("tx-Size: " + tx_src.width + " " + tx_src.height);
      texture = createImage(w, h, RGB);
      for (int x_tx=0; x_tx < w; x_tx += tx_src.width) {
        for (int y_tx=0; y_tx < h; y_tx += tx_src.height) {
          //println(x_tx + " " + y_tx);
          texture.set(x_tx, y_tx, tx_src);
        }
      }
    }*/
    
  }
  
  void assignTexture (PImage newTexture) {
    if (newTexture!=null) texture = newTexture;
  }
  
  PImage stitchRepeatingTexture (PImage newTexture) {
    PImage stitchedTexture, rotatedSubTx;
    stitchedTexture = createImage(w, h, ARGB);
    int subTxWidth = 50;
    int subTxHeight = subTxWidth;
    if (newTexture != null) {
      //println("tx-Size: " + tx_src.width + " " + tx_src.height);
      for (int x_tx=0; x_tx < w; x_tx += subTxWidth) {
        for (int y_tx=0; y_tx < h; y_tx += subTxHeight) {
          /*
          //println(x_tx + " " + y_tx);
          int r = int(random(0,4));
          //println(r);
          pushMatrix();
          translate(subTxWidth/2, subTxHeight/2);
          for(int i=0; i<r; i++) {
            
          }
          rotate(PI);
          translate(-subTxWidth/2, -subTxHeight/2);
          rotatedSubTx=newTexture;
          popMatrix();*/
          stitchedTexture.set(x_tx, y_tx, newTexture);
        }
      }
    }
    return stitchedTexture;
  }
  
  void move() {};
  
  void display(){
    if (texture==null) {
      stroke(255);
      strokeWeight(2);
      fill(col);
      rect(x,y,(float)w,(float)h);
    }
    else if (texture!=null) image(texture,x,y,w,h);
    
    if (debugMode) {
      noFill();
      strokeWeight(4);
      stroke(150,150,150);
      
      rect(x,y,w,h);
      
      debugShowSemisolid();
    }
  }
  
  void debugShowSemisolid() {
    if(semisolid != '0') {
      textAlign(CENTER);
      textSize(32);
      fill(100,230,150);
      if(semisolid == 'u') {
        text('^',x+w/2,y+h/2);
      } else if(semisolid == 'd') {
        pushMatrix();
        translate(x+w/2,y+h/2);
        rotate(PI);
        text('^',0,0);
        popMatrix();
      } else if(semisolid == 'r') {
        pushMatrix();
        translate(x+w/2,y+h/2);
        rotate(PI/2);
        text('^',0,0);
        popMatrix();
      } else if(semisolid == 'l') {
        pushMatrix();
        translate(x+w/2,y+h/2);
        rotate(3*PI/2);
        text('^',0,0);
        popMatrix();
      }
    }
  }
  
  void hit(){
  }
  void noHit(){
    
  }
  
}

class MovableEntity extends Entity {
  float newX, newY;
  float vSpeed, hSpeed;
  boolean grounded = false;
  Entity groundedOn;
  
  MovableEntity(float x, float y, int w, int h, char semisolid){
    super(x,y,w,h,semisolid);
  }
  
  
  float checkBottomCollision(MovableEntity o1, Entity o2){
    //only get here if Object1's vSpeed is > 0 (moving downwards) 
    // - and theoretically if not (grounded = true && hSpeed = 0)
    float newo1BottomCollider = o1.newY+o1.h;
    float o1BottomCollider = o1.y+o1.h;
    float o2TopCollider = o2.y;
    
    //are they on same x-Space?
    if (o1.x >= o2.x && o1.x < o2.x+o2.w  ||  o2.x >= o1.x && o2.x < o1.x+o1.w ) {
      //println(o2.getClass().getName() + " wird gecheckt");
      //was o2 currently even below o1 to begin with
      if (o1BottomCollider <= o2TopCollider){
        if (newo1BottomCollider >= o2TopCollider){ //== will it collide
          //println("gnd");
          float newnewo1BottomCollider = o2TopCollider;
          float collY = newnewo1BottomCollider - o1.h;
          //o1.grounded = true;
          //o1.groundedOn = o2;
          return collY;
        } else {
          //no movement + vSpeed = 0 + isGrounded = true
          //willBeGrounded = true
          //println("std freefall");
          return -1;
        }
      }
    }
    //else { println("nicht gecheckt"); }
    //if not on same x-Space or already above o1
    
    return -1;
  }
  
  float checkTopCollision(MovableEntity o1, Entity o2) {
    float newo1TopCollider = o1.newY;
    float o1TopCollider = o1.y;
    float o2BottomCollider = o2.y + o2.h;
    
    //are they on same x-Space?
    if (o1.x >= o2.x && o1.x < o2.x+o2.w   ||  o2.x >= o1.x && o2.x < o1.x+o1.w ) {
      //was o2 currently even above o1 to begin with
      if (o1TopCollider >= o2BottomCollider){
        if (newo1TopCollider <= o2BottomCollider){ //==> will it be grounded
          float newnewo1TopCollider = o2BottomCollider;
          float collY = newnewo1TopCollider - 0;
          //actually isTopped, but for now to stop vSpeed:
          //o1.grounded = true;
          //o1.groundedOn = o2;
          return collY;
        } else {
          //if not colliding
          return -1;
        }
      }
    }
    //if not in same x-Space or already below o1
    return -1;
  }
  
  float checkRightCollision(MovableEntity o1, Entity o2){
    float newo1RightCollider = o1.newX+o1.w;
    float o1RightCollider = o1.x+o1.w;
    float o2LeftCollider = o2.x;
    
    //are they on same y-Space?
    if (o1.newY >= o2.y && o1.newY < o2.y+o2.h   ||  o2.y >= o1.newY && o2.y < o1.newY+o1.h ) {
      //println(o2.getClass().getName() + " wird gecheckt");
      //was o2 currently even to the right o1 to begin with
      if (o1RightCollider <= o2LeftCollider){
        if (newo1RightCollider >= o2LeftCollider){ //==> will it be touching it with the right side
          float newnewo1RightCollider = o2LeftCollider;
          float collX = newnewo1RightCollider - o1.w;
          // collisio left triggered
          o1.hSpeed = 0;
          
          return collX;
        } else {
          //if not colliding
          return -1;
        }
      }
    }
    //else { println("nicht gecheckt"); }
    //if not in the same y-Space or already left of o1
    return -1;
  }
  
  float checkLeftCollision(MovableEntity o1, Entity o2){
    float newo1LeftCollider = o1.newX;
    float o1LeftCollider = o1.x;
    float o2RightCollider = o2.x+o2.w;
    
    
    
    //are they on same y-Space?
    if (o1.newY >= o2.y && o1.newY < o2.y+o2.h   ||  o2.y >= o1.newY && o2.y < o1.newY+o1.h ) {
      //was o2 currently even to the left o1 to begin with
      if (o1LeftCollider >= o2RightCollider){
        if (newo1LeftCollider <= o2RightCollider) {
          float newnewo1LeftCollider = o2RightCollider;
          float collX = newnewo1LeftCollider - 0;
          //
          o1.hSpeed = 0;
          
          return collX;
        } else {
          //if not colliding
          return -1;
        }
      }
    }
    //if not in the same y-Space or already right of o1
    return -1;
  }
  
}
