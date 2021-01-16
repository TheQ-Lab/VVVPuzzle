class Level{
  JSONArray entityJsons;
  PImage bg, fg, tx_block, tx_semisolid, tx_floatBlock_a, tx_floatBlock_b, tx_teleport, tx_goal, bg_tut_1, bg_tut_2, bg_tut_3, bg_tut_4;
  int levelNumber;
  
  PImage stitchedTexture, stitchedTexture_b;
  
  Level (int noLvl) {
    levelNumber = noLvl;
    importLevel(noLvl);
    bg = loadImage("assets/environment/background_textured.png");
    fg = loadImage("assets/environment/foreground_c.png");
    tx_block = loadImage("assets/entities/tx_block_a.png");
    tx_semisolid = loadImage("assets/entities/tx_semisolid.png");
    tx_floatBlock_a = loadImage("assets/entities/float_d.png");
    tx_floatBlock_b = loadImage("assets/entities/float_c.png");
    tx_teleport = loadImage("assets/entities/teleport_a.png");
    tx_goal = loadImage("assets/entities/goal.png");
    bg_tut_1 = loadImage("assets/environment/bg-tut_1.png");
    bg_tut_2 = loadImage("assets/environment/bg-tut_2.png");
    bg_tut_3 = loadImage("assets/environment/bg-tut_3.png");
    bg_tut_4 = loadImage("assets/environment/bg-tut_4.png");
    generateLevel();
    surface.setTitle("Fires Escape from the Darkness - Level " + int(levelNumber));
  }
  
  void importLevel(int noLvl) {
    String filePath = "levels/";
    String fileName = "level";
    if (noLvl<10) { fileName += "0"; }
    fileName += str(noLvl);
    fileName += ".json";
    println(fileName);
    entityJsons = loadJSONArray(filePath + fileName);
  }
  
  void generateLevel() {
    for (int i=0; i<entityJsons.size(); i++) {
      JSONObject newEntity = entityJsons.getJSONObject(i);
      
      int x = newEntity.getInt("x"); //int
      int y = newEntity.getInt("y"); //int
      int w = newEntity.getInt("w"); //int
      int h = newEntity.getInt("h"); //int
      char semisolid;
      char gravityDirection;
      
      String entityType = newEntity.getString("entityType").trim().toString();
      
      switch(entityType){
        case "Character":
          if (character!=null) character.teleport(x,y);
          break;
        case "En":
          if (newEntity.isNull("semisolid")) {
            semisolid = '0';
          } else {
            semisolid = newEntity.getString("semisolid").charAt(0); // 0,u,d,l,r
          }
          
          Entity e = new Entity(x,y,w,h,semisolid);
          
          if (semisolid == '0') {
            stitchedTexture = e.stitchRepeatingTexture(tx_block);
            e.assignTexture(stitchedTexture); 
          } else {
            stitchedTexture = e.stitchRepeatingTexture(tx_semisolid);
            e.assignTexture(stitchedTexture); 
          }
          
          entities.add(e);
          break;
        case "FB":
          if (newEntity.isNull("semisolid")) {
            semisolid = '0';
          } else {
            semisolid = newEntity.getString("semisolid").charAt(0); // 0,u,d,l,r
          }
          if (newEntity.isNull("gravityDirection")) {
            gravityDirection = 'd';
          } else {
            gravityDirection = newEntity.getString("gravityDirection").charAt(0); // d,u
          }
        
          FloatBlock f = new FloatBlock(x,y,w,h,semisolid,gravityDirection);
          
          stitchedTexture = f.stitchRepeatingTexture(tx_floatBlock_a);
          stitchedTexture_b = f.stitchRepeatingTexture(tx_floatBlock_b);
          f.assignTexture(stitchedTexture, stitchedTexture_b);
          
          entities.add(f);
          break;
        /*
        case "Trigger":
          String type;
          if (newEntity.isNull("type")) {
            type = "goal";
          } else {
            type = newEntity.getString("type").trim().toString(); // goal, teleport
          }
          semisolid = 't';
          Trigger legacy;
          if (type.equals("goal")) {
            int nextLevel = 1;
            if (!newEntity.isNull("nextLevel")) {
              nextLevel = newEntity.getInt("nextLevel");
            }
            legacy = new Goal(x,y,w,h,semisolid,nextLevel);
            legacy.assignTexture(tx_goal);
            entities.add(t);
          } else if (type.equals("teleport")) {
            float x2 = newEntity.getFloat("x2");
            float y2 = newEntity.getFloat("y2");
            legacy = new Teleport(x,y,w,h,semisolid,x2,y2);
            entities.add(legacy);
          }
          //Trigger legacy = new Trigger(type,x,y,w,h,semisolid);
          break;
        */
        case "Goal":
          semisolid = 't';
          int nextLevel = 1;
          if (!newEntity.isNull("nextLevel")) {
            nextLevel = newEntity.getInt("nextLevel");
          }
          Goal g = new Goal(x,y,w,h,semisolid,nextLevel);
          g.assignTexture(tx_goal);
          entities.add(g);
          break;
        case "Teleport":
          semisolid = 't';
          float x2 = newEntity.getFloat("x2");
          float y2 = newEntity.getFloat("y2");
          Teleport t = new Teleport(x,y,w,h,semisolid,x2,y2);
          t.assignTexture(tx_teleport);
          entities.add(t);
          break;
      }
    }
  }
  
  void loadLevel(int newLevelNo) {
    for (int i = entities.size() - 1; i >= 0; i --){
      Entity e = entities.get(i);
      entities.remove(e);
    }
    for (int i = projectiles.size() - 1; i >= 0; i --){
      Projectile p = projectiles.get(i);
      projectiles.remove(p);
    }
    level.importLevel(newLevelNo);
    level.generateLevel();
    this.levelNumber = newLevelNo;
    surface.setTitle("Fires Escape from the Darkness - Level " + int(levelNumber));
    delay(100);
  }
}
