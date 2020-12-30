class Projectile {
  float x, y;
  int w, h;
  char direction;
  float speed = 10;
  boolean willDespawn;
  PImage texture;
  
  Projectile (float x, float y, int w, int h, char direction){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    if (direction == 'u' || direction == 'd') {
      this.w = h;
      this.h = w;
    }
    this.direction = direction;
  }
  
  void assignTexture (PImage newTexture) {
    if (newTexture!=null) texture = newTexture;
  }
  
  void move() {
    if (direction == 'r') {
      this.x += speed;
    } else if (direction == 'l') {
      this.x -= speed;
    } else if (direction == 'u') {
      this.y -= speed;
    } else if (direction == 'd') {
      this.y += speed;
    }
  }
  
  void display(){
    if (texture==null) {
      stroke(255);
      strokeWeight(2);
      fill(255);
      rect(x,y,(float)w,(float)h);
    }
    else if (texture!=null) {
      pushMatrix();
      translate(x,y);
      if (direction == 'r') {
        
        image(texture,0,0,w,h);
      } else if (direction == 'l') {
        rotate(PI);
        image(texture,-w,-h,w,h);
      } else if (direction == 'u') {
        rotate((1.5*PI));
        image(texture,-h,0,h,w);
      } else if (direction == 'd') {
        rotate(PI/2);
        image(texture,0,-w,h,w);
      }
      popMatrix();
    }
    if (debugMode) {
      noFill();
      strokeWeight(4);
      stroke(150,150,150);
      
      rect(x,y,w,h);
    }
  }
  
  boolean checkDespawn() {
    if (x>width || x<0 || y>height || y<0){
      willDespawn = true;
      return true;
    }
    return false;
  }
  
  boolean collision() {
    for (Entity o2 : entities) { //<>//
      //check if in same X-Space
      if (o2.semisolid=='t') { continue; } //<>//
      if (x>=o2.x&&x<=o2.x+o2.w || x+w>=o2.x&&x+w<=o2.x+o2.w) {
        //check if in same Y-Space
        if (y>=o2.y&&y<=o2.y+o2.h || y+h>=o2.y&&y+h<=o2.y+o2.h) {
          o2.hit();
          willDespawn = true;
          return true;
        }
      }
    }
    return false;
  }
  
}
