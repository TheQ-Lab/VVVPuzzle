import processing.sound.*;

SoundFile bgm;
SoundFile sfx_goal;

void setupMusic() {
  bgm = new SoundFile(VVVPuzzle.this, "music/Forbidding_Corridors_cut.wav");
  sfx_goal = new SoundFile(VVVPuzzle.this, "music/Special_Item_Get.wav");
  
  if (musicOff)
   return;
  bgm.amp(0.9);
  bgm.loop();
}

void restartBgm() {
  if (musicOff)
    return;
  bgm.stop();
  bgm.loop();
}

public void stopBgm() {
  bgm.stop();
}

void playSfx() {
  if (musicOff)
   return;
  sfx_goal.stop();
  sfx_goal.amp(0.5);
  sfx_goal.cue(0);
  sfx_goal.play();
}
