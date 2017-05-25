int indexCurTarget = 0;

Easing[] easings = { 
  Ani.LINEAR, Ani.QUAD_IN, Ani.QUAD_OUT, Ani.QUAD_IN_OUT, Ani.CUBIC_IN, Ani.CUBIC_IN_OUT, Ani.CUBIC_OUT, Ani.QUART_IN, Ani.QUART_OUT, Ani.QUART_IN_OUT, Ani.QUINT_IN, Ani.QUINT_OUT, Ani.QUINT_IN_OUT, Ani.SINE_IN, Ani.SINE_OUT, Ani.SINE_IN_OUT, Ani.CIRC_IN, Ani.CIRC_OUT, Ani.CIRC_IN_OUT, Ani.EXPO_IN, Ani.EXPO_OUT, Ani.EXPO_IN_OUT, Ani.BACK_IN, Ani.BACK_OUT, Ani.BACK_IN_OUT, Ani.BOUNCE_IN, Ani.BOUNCE_OUT, Ani.BOUNCE_IN_OUT, Ani.ELASTIC_IN, Ani.ELASTIC_OUT, Ani.ELASTIC_IN_OUT
};

String[] easingsVariableNames = {
  "Ani.LINEAR", "Ani.QUAD_IN", "Ani.QUAD_OUT", "Ani.QUAD_IN_OUT", "Ani.CUBIC_IN", "Ani.CUBIC_IN_OUT", "Ani.CUBIC_OUT", "Ani.QUART_IN", "Ani.QUART_OUT", "Ani.QUART_IN_OUT", "Ani.QUINT_IN", "Ani.QUINT_OUT", "Ani.QUINT_IN_OUT", "Ani.SINE_IN", "Ani.SINE_OUT", "Ani.SINE_IN_OUT", "Ani.CIRC_IN", "Ani.CIRC_OUT", "Ani.CIRC_IN_OUT", "Ani.EXPO_IN", "Ani.EXPO_OUT", "Ani.EXPO_IN_OUT", "Ani.BACK_IN", "Ani.BACK_OUT", "Ani.BACK_IN_OUT", "Ani.BOUNCE_IN", "Ani.BOUNCE_OUT", "Ani.BOUNCE_IN_OUT", "Ani.ELASTIC_IN", "Ani.ELASTIC_OUT", "Ani.ELASTIC_IN_OUT"
};

class Choreo {
  float aniRot = 0;
  float aniRotNo = 0;
  float aniTransX = 0;
  float aniTransY = 0;
  float aniTransZ = 0;
  float aniSizeX = 0;
  float aniSizeY = 0;
  float aniTri = 0;

  PApplet p5;
  AniSequence seq;
  float currentSeek = 0;

  float speed = 0.20;
  float delay = 0.0;
  int easingType = 6;//26;

  String[] transTasks = {
    "aniRot", "aniRotNo", "aniTransX", "aniTransY", "aniTransZ", "aniSizeX", "aniSizeY", "aniTri"
  };
  String[] toDoTasks = {
  };

  public Choreo(PApplet p5I) {
    p5 = p5I;
  }

  public void setupAni() {
    speed = cp5TransSpeed;
    delay = cp5TransDelay;

    seq = new AniSequence(p5);
    seq.beginSequence();

    aniRot = 0;
    aniRotNo = 0;
    aniSizeX = 0;
    aniSizeY = 0;
    aniTransX = 0;
    aniTransY = 0;
    aniTransZ = 0;
    aniTri = 0;

    for (int i = 0; i < toDoTasks.length; i++) {
      seq.beginStep();
      for(String key: transTasks) {
        if (toDoTasks[i].equals(key))
          seq.add(Ani.to(this, speed, delay, key, 100, easings[easingType%easings.length]));
      }
      seq.endStep();
    }
    seq.endSequence();
    if (cp5PlaybackStyle == 1) seq.start();
    else seq.pause();
  }

  public void setup(TransformInfo info) {
    toDoTasks = new String[0]; 

    if (info.rotNormAmount == 1) toDoTasks = append(toDoTasks, transTasks[1]);
    if (info.rotAmount == 1) toDoTasks = append(toDoTasks, transTasks[0]);
    if (info.transAmountY == 1) toDoTasks = append(toDoTasks, transTasks[3]);
    if (info.transAmountZ == 1) toDoTasks = append(toDoTasks, transTasks[4]);
    if (info.transAmountX == 1) toDoTasks = append(toDoTasks, transTasks[2]);
    if (info.sizeAmountY == 1) toDoTasks = append(toDoTasks, transTasks[6]);
    if (info.sizeAmountX == 1) toDoTasks = append(toDoTasks, transTasks[5]);
    if (info.triAmount == 1) toDoTasks = append(toDoTasks, transTasks[7]);

    if (cp5Shuffle) Collections.shuffle(Arrays.asList(toDoTasks));

    setupAni();
  }

  public void update() {
    if (seq != null) {
      if (cp5PlaybackStyle == 2) {
        seq.seek((sin(((float)frameCount / 100.0)) + 1) / 2.0);
        seq.resume();
      }

      if (cp5PlaybackStyle == 3) {
        float seekValue = cp5SeekAniValue;
        seq.seek(seekValue);
        seq.resume();
      }

      transform.update(aniRot / 100.0, aniRotNo / 100.0, aniTransX / 100.0, aniTransY / 100.0, aniTransZ / 100.0, aniSizeX / 100.0, aniSizeY / 100.0, aniTri / 100.0);
    }
    if (checkAniEnded()) {
      nextMorphTarget();
    }
  }

  boolean checkAniEnded() {
    if (seq != null)
      return seq.isEnded();
    else
      return true;
  }

  boolean contains(String task) {
    for (int i = 0; i < toDoTasks.length; i++) {
      if (toDoTasks[i].equals(task))
        return true;
    }
    return false;
  }

  void changePlayback() {
    if (seq != null) {
      if (cp5PlaybackStyle == 1) {
        jumpNextTarget();
      }
      if (cp5PlaybackStyle == 2) {
        seq.pause();
      }
      if (cp5PlaybackStyle == 3) {
        seq.pause();
      }
    }
  }

  void jumpNextTarget() {   
    init();
  }

  void nextMorphTarget() {
    visEdges.enter(transform.transformBody, true);    
    init();
  }

  void init() {
    if (seq != null) seq.pause();

    indexCurTarget = (indexCurTarget + 1) % listofBody.length;

    int number = listofBody[indexCurTarget];
    getNextRandomBody(number);
    transform.updateNewTarget(body[number], true);
    setup(transform.info);
  }
}