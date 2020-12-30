void postProcessing() {
  volumetric();
  foreground();
}

void foreground() {
  image(level.fg,0,0);
}

void volumetric() {
  for (Entity o : entities) {
    if (o instanceof FloatBlock) {
      FloatBlock fb = (FloatBlock) o; //converts an Entity o explicitly into FloatBlock with()
      boolean splitUp = fb.splitUp;
      if (splitUp == false) {
        //blue tint
        coloredHalo(color(50,50,230), fb);
      } else if (splitUp == true) {
        //red tint
        coloredHalo(color(230,80,50), fb);
      }
    }
  }
}

void coloredHalo(color c, Entity e) {
  int x = (int)e.x; int y = (int)e.y; int w = (int)e.w; int h = (int)e.h;
  
  int maxOpacity = 200; //int minOpacity = 0;
  int steps = 15;
  noStroke();
  
  //right side
  for (int i=0; i<steps; i++) {
    float opacity = maxOpacity - (((float)i/steps) * maxOpacity);
    //println(opacity);
    fill(c, opacity);
    
    //Without corners
    /*rect(x+w + (i), y+1, 1, h-1);
    rect(x + (-i) -1, y+1, 1, h-1);
    rect(x, y + (-i), w, 1);
    rect(x, y+h + i, w, 1);*/
    
    //Test exact diagonal line
    //rect(x-1 + (-i),y + (-i),1,1);
    
    //With sharp corners
    rect(x+w + (i), y+1 -i-1, 1, h-1 +(2*i)+1);
    rect(x + (-i) -1, y+1 -i, 1, h-1 +(2*i)+1);
    rect(x - i-1, y + (-i), w +(2*i)+1, 1);
    rect(x - i, y+h + i, w +(2*i) + 1, 1);
    
    
  }
  //With tint over Block
  /*fill(c, 50);
  rect(x, y +1, w, h);*/
}
