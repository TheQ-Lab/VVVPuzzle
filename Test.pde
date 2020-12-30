class Test {
  int blockX,blockY;
  boolean lmbPressed = false;
  
  Test(){
    
  }
  
  void testLoop() {
    printNewBlockCoordinates();
    //println("Character at " + character.x + " " + character.y);
  }
 
  void printNewBlockCoordinates() {
    //trigger onClick
    if (!lmbPressed) {
      if (mousePressed) {
        blockX = mouseX;
        blockY = mouseY;
        lmbPressed = true;
      }
    } else if (lmbPressed) {
      if (!mousePressed) {
        println("x:" + blockX + " y:" + blockY + " w:" + (mouseX-blockX) + " h:" + (mouseY-blockY));
        lmbPressed = false;
      }
    }
    //println(mouseX + ' ' + mouseY);
  }
  void vpheight(){
    println(VVVPuzzle.h);
  }
  
  
  
}
