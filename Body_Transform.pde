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
    for (int i = 0; i < transformBody.element.length; i++) {
      info.enterMeshTransInfo(transformBody.element[i].meshTransform.info);
    }
    info.invert();    

    for (int g = 0; g < transformBody.element.length; g++) {
      transformBody.element[g].meshTransform.motionClap = motionClap;
    }
  }

  void init() {
    //only check for targetargetBody if the array of targetargetBody is not empty
    if (targetBody.element.length > 0 && transformBody.element.length > 0) {

      if (transformBody.element.length < targetBody.element.length) resizeOriginClosest();
      for (int g = 0; g < transformBody.element.length; g++) {
        int indexChosenT = -1;
        int indexChosenC = -1;

        if (g % targetBody.element.length == 0) {
          for (int j = 0; j < max(targetBody.element.length, transformBody.element.length); j++) {
            if (targetBody.element.length > j)
              targetBody.element[j].chosen=false;
          }
        }     

        float distV = 10000000;
        float distC = 0;

        MeshElement[] eTrans = transformBody.element;
        MeshElement[] eTarget = targetBody.element;
        for (int i = 0; i < eTrans.length; i++) {

          // if this element not already found itargetBody target
          if (!eTrans[i].chosen) {

            for (int j = 0; j < eTarget.length; j++) {
              //if this target has not yet been found
              if (!eTarget[j].chosen) {

                distC = dist(eTrans[i].center.x, eTrans[i].center.y, eTrans[i].center.z, eTarget[j].center.x, eTarget[j].center.y, eTarget[j].center.z);

                if (distC < distV) {
                  indexChosenT = j;
                  indexChosenC = i;
                  distV = distC;
                }
              }
            }
          }
        }

        eTrans[indexChosenC].chosen = true;
        eTarget[indexChosenT].chosen = true;
        eTrans[indexChosenC].setTargetElement(eTarget[indexChosenT]);
      }
      //search closest
    }
  }

  void resizeOriginClosest() {
    int n = 0;
    float distLast = 1000000;
    for (int i = transformBody.element.length; i < targetBody.element.length; i++) {

      for (int j = 0; j < transformBody.element.length; j++) {
        float distCheck = transformBody.element[j].center.distanceTo(targetBody.element[i].center);
        if (distCheck < distLast) {
          distLast = distCheck;
          n = j;
        }
      }

      transformBody.element = (MeshElement[])append(transformBody.element, new MeshElement(transformBody.element[n].mesh));
    }
  }

  public void update(float aniRot, float aniRotNo, float aniTransX, float aniTransY, float aniTransZ, float aniSizeX, float aniSizeY, float triAmount) {
    for (int i = 0; i < transformBody.element.length; i++)
      transformBody.element[i].update(aniRot, aniRotNo, aniTransX, aniTransY, aniTransZ, aniSizeX, aniSizeY, triAmount);
  }

  public void drawDebug() {
    showDebugVertNum %= transformBody.element.length;
    showDebugVertNum = abs(showDebugVertNum);

    for (int i = 0; i < transformBody.element.length; i++) {
      if (showDebugVertNum == i) {
        pushStyle();
        fill(255, 0, 255);
        //drawMesh(transformBody.element[i].meshTransform.cur, color(255, 255, 0), true,true);
        //drawMesh(transformBody.element[i].meshTransform.dst, color(255, 255, 0), true,false);
        popStyle();
      }
    }
  }
}