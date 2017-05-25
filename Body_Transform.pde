class BodyTransform {

  TransformInfo info;

  Body transformBody = new Body();
  Body sourceBody = new Body();
  Body targetBody = new Body();

  // animation Modes
  boolean motionClap = false;

  public BodyTransform(Body cI, Body tI) {
    transformBody = new Body(cI);
    targetBody = tI;
    sourceBody = cI;
    reset();
  }

  void updateNewTarget(Body tI, boolean overWrite) {
    if (overWrite) {
      transformBody = new Body(targetBody);
      sourceBody = new Body(targetBody);
      targetBody = tI;
    } else {
      targetBody = tI;
      transformBody = new Body(transformBody);
      sourceBody = new Body(transformBody);
    }
    reset();

    trails.setup(transformBody);
  }

  public void reset() {
    info = new TransformInfo();
    init();
    checkTransInfo();
  }

  void checkTransInfo() {
    for (int i = 0; i < transformBody.element.size(); i++) {
      info.enterMeshTransInfo(transformBody.element.get(i).meshTransform.info);
    }
    info.invert();    

    for (int g = 0; g < transformBody.element.size(); g++) {
      transformBody.element.get(g).meshTransform.motionClap = motionClap;
    }
  }

  void init() {
    //only check for targetargetBody if the array of targetargetBody is not empty
    if (targetBody.element.size() > 0 && transformBody.element.size() > 0) {

      if (transformBody.element.size() < targetBody.element.size()) resizeOriginClosest();
      for (int g = 0; g < transformBody.element.size(); g++) {
        int indexChosenT = -1;
        int indexChosenC = -1;

        if (g % targetBody.element.size() == 0) {
          for (int j = 0; j < max(targetBody.element.size(), transformBody.element.size()); j++) {
            if (targetBody.element.size() > j)
              targetBody.element.get(j).chosen=false;
          }
        }     

        float distV = 10000000;
        float distC = 0;

        ArrayList<MeshElement> eTrans = transformBody.element;
        ArrayList<MeshElement> eTarget = targetBody.element;
        for (int i = 0; i < eTrans.size(); i++) {

          // if this element not already found itargetBody target
          if (!eTrans.get(i).chosen) {

            for (int j = 0; j < eTarget.size(); j++) {
              //if this target has not yet been found
              if (!eTarget.get(j).chosen) {

                distC = dist(eTrans.get(i).center.x, eTrans.get(i).center.y, eTrans.get(i).center.z, eTarget.get(j).center.x, eTarget.get(j).center.y, eTarget.get(j).center.z);

                if (distC < distV) {
                  indexChosenT = j;
                  indexChosenC = i;
                  distV = distC;
                }
              }
            }
          }
        }

        eTrans.get(indexChosenC).chosen = true;
        eTarget.get(indexChosenT).chosen = true;
        eTrans.get(indexChosenC).setTargetElement(eTarget.get(indexChosenT));
      }
      //search closest
    }
  }

  void resizeOriginClosest() {
    int n = 0;
    float distLast = 1000000;
    for (int i = transformBody.element.size(); i < targetBody.element.size(); i++) {

      for (int j = 0; j < transformBody.element.size(); j++) {
        float distCheck = transformBody.element.get(j).center.distanceTo(targetBody.element.get(i).center);
        if (distCheck < distLast) {
          distLast = distCheck;
          n = j;
        }
      }

      transformBody.element.add(new MeshElement(transformBody.element.get(n).mesh));
    }
  }

  public void update(float aniRot, float aniRotNo, float aniTransX, float aniTransY, float aniTransZ, float aniSizeX, float aniSizeY, float triAmount) {
    for (int i = 0; i < transformBody.element.size(); i++)
      transformBody.element.get(i).update(aniRot, aniRotNo, aniTransX, aniTransY, aniTransZ, aniSizeX, aniSizeY, triAmount);
  }

  public void drawDebug() {
    showDebugVertNum %= transformBody.element.size();
    showDebugVertNum = abs(showDebugVertNum);

    for (int i = 0; i < transformBody.element.size(); i++) {
      if (showDebugVertNum == i) {
        pushStyle();
        fill(255, 0, 255);
        //drawMesh(transformBody.element.get(i).meshTransform.cur, color(255, 255, 0), true,true);
        //drawMesh(transformBody.element.get(i).meshTransform.dst, color(255, 255, 0), true,false);
        popStyle();
      }
    }
  }
}