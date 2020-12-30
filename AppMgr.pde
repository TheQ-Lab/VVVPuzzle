class AppMgr {
  ArrayList<String> tasks;
  
  AppMgr() {
    tasks = new ArrayList<String>();
  }
  
  void loop() {
    if (tasks.size() > 0) {
      for (int i=0; i<tasks.size(); i++) {
        String t = tasks.get(i);
        if (t == "loadLevel:") {
          i++;
          int nextLvl = int(tasks.get(i));
          level.loadLevel(nextLvl);
        } else if (t == "andereAufgabe") {}
      }
      
      tasks.clear();
    }
    
  }
  
  void addTask(String s) {
    tasks.add(s);
  }
}
