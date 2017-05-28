Body[] body = new Body[5];

// TODO: should be defined in GUI?
int[] listofBody = {
  0, 1, 2, 3, 4
};

String[] nameofBody = {
  "Point", "Line", "Plate", "Triangle", "Box"
};

int calcRandomValue(int from, int to) {
  int val = (int)random(from, to + 1);

  return constrain(val, from, to);
} 

int calcRandomValue(float from, float to) {
  float val = (int)random(from, to + 1);

  return (int)constrain(val, from, to);
} 

void setupBodyPrimitives() {
  for (int i = 0; i < body.length; i++) {
    body[i] = new Body(i);
  }
}

int numRandomBody = 0;
void getNextRandomBody(int i) {
  // TODO: why crashes?
  //body[i].reset();
  body[i] = new Body(i);
  numRandomBody++;
  println(numRandomBody);
}

float globalScaleMult = 0.5;

WETriangleMesh create() {
  WETriangleMesh meshI = new WETriangleMesh();
  Vec3D a = new Vec3D(-1, 1, 0);
  Vec3D b = new Vec3D(-1, -1, 0);
  Vec3D c = new Vec3D(1, -1, 0);
  Vec3D d = new Vec3D(1, 1, 0);

  meshI.addFace(a, b, c);
  meshI.addFace(c, d, a);

  m.setScale(meshI, calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult));
  m.setRandRot(meshI);
  //m.setTrans(meshI, new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  return meshI;
}

WETriangleMesh create(Vec3D A, Vec3D B, float heightV) {
  WETriangleMesh meshI = new WETriangleMesh();
  Vec3D a = new Vec3D(A.x, A.y+heightV, A.z);
  Vec3D b = new Vec3D(A.x, A.y-heightV, A.z);
  Vec3D c = new Vec3D(B.x, B.y-heightV, B.z);
  Vec3D d = new Vec3D(B.x, B.y+heightV, B.z);

  meshI.addFace(a, b, c);
  meshI.addFace(c, d, a);
  return meshI;
}

WETriangleMesh create(Vec3D a, Vec3D b, Vec3D c, Vec3D d) {
  WETriangleMesh meshI = new WETriangleMesh();

  meshI.addFace(a, b, c);
  meshI.addFace(c, d, a);
  return meshI;
}

class PMesh {
  String type;
  WETriangleMesh[] meshes;

  public PMesh() {
    type = "mesh";
    meshes = new WETriangleMesh[1];
    meshes[0] = new WETriangleMesh();
  }

  void setTrans(Vec3D posI) {
    Vec3D pos = new Vec3D(posI.x, posI.y, posI.z);
    for (int i = 0; i < meshes.length; i++) {
      m.setTrans(meshes[i], pos);
    }
  }

  void setRandRot() {
    if (!cp5QuantAnim)
      setRot(m.getRandVector(false), random(-1, 1) * PI / 2);
    else {    
      setRot(m.getRandVector(true), (int)random(-2, 2) * PI / 2);
    }
  }

  void setRot(Vec3D dir, float amount) {
    for (int i = 0; i < meshes.length; i++)
      m.setRot(meshes[i], dir, amount);
  }

  void setScale(float wI, float hI, float dI) {
    for (int i = 0; i < meshes.length; i++) {
      m.setScale(meshes[i], wI, hI, dI);
    }
  }
}

class PBox extends PMesh {
  public PBox() {
    setup();

    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult));
    setRandRot();
    setTrans(new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }

  public PBox(float wI, float hI, float dI) {
    setup();
    setScale(wI, hI, dI);
  }

  public void setup() {
    type = "box";
    meshes = new WETriangleMesh[6];
    meshes[0] = create(new Vec3D( 1.0f, 1.0f, -1.0f), // Top Right Of The Quad (Top)
      new Vec3D(-1.0f, 1.0f, -1.0f), // Top Left Of The Quad (Top)
      new Vec3D(-1.0f, 1.0f, 1.0f), // Bottom Left Of The Quad (Top)
      new Vec3D( 1.0f, 1.0f, 1.0f));    // Bottom Right Of The Quad (Top)

    meshes[1] = create(new Vec3D( 1.0f, -1.0f, 1.0f), // Top Right Of The Quad (Bottom)
      new Vec3D(-1.0f, -1.0f, 1.0f), // Top Left Of The Quad (Bottom)
      new Vec3D(-1.0f, -1.0f, -1.0f), // Bottom Left Of The Quad (Bottom)
      new Vec3D( 1.0f, -1.0f, -1.0f));    // Bottom Right Of The Quad (Bottom)

    meshes[2] = create(new Vec3D( 1.0f, 1.0f, 1.0f), // Top Right Of The Quad (Front)
      new Vec3D(-1.0f, 1.0f, 1.0f), // Top Left Of The Quad (Front)
      new Vec3D(-1.0f, -1.0f, 1.0f), // Bottom Left Of The Quad (Front)
      new Vec3D( 1.0f, -1.0f, 1.0f));    // Bottom Right Of The Quad (Front)

    meshes[3] = create(new Vec3D( 1.0f, -1.0f, -1.0f), // Top Right Of The Quad (Back)
      new Vec3D(-1.0f, -1.0f, -1.0f), // Top Left Of The Quad (Back)
      new Vec3D(-1.0f, 1.0f, -1.0f), // Bottom Left Of The Quad (Back)
      new Vec3D( 1.0f, 1.0f, -1.0f));    // Bottom Right Of The Quad (Back)

    meshes[4] = create(new Vec3D(-1.0f, 1.0f, 1.0f), // Top Right Of The Quad (Left)
      new Vec3D(-1.0f, 1.0f, -1.0f), // Top Left Of The Quad (Left)
      new Vec3D(-1.0f, -1.0f, -1.0f), // Bottom Left Of The Quad (Left)
      new Vec3D(-1.0f, -1.0f, 1.0f));    // Bottom Right Of The Quad (Left)

    meshes[5] = create(new Vec3D( 1.0f, 1.0f, -1.0f), // Top Right Of The Quad (Right)
      new Vec3D( 1.0f, 1.0f, 1.0f), // Top Left Of The Quad (Right)
      new Vec3D( 1.0f, -1.0f, 1.0f), // Bottom Left Of The Quad (Right)
      new Vec3D( 1.0f, -1.0f, -1.0f));    // Bottom Right Of The Quad (Right)
  }
}

class PLine extends PMesh {
  public PLine() {
    super();
    type = "line";
    meshes[0] = create(new Vec3D(-1, 0, 0), new Vec3D(+1, 0, 0), 0.01);
    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), 1, 1);
    setRandRot();
    //setTrans(new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }
}

static float pPointSize = 0.005;

class PPoint extends PMesh {
  public PPoint() {
    super();
    //Vec3D posI = new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY));
    Vec3D posI = new Vec3D(0, 0, 0);
    setup(posI);
  }
  public PPoint(Vec3D posI) {
    super();
    setup(posI);
  }

  void setup(Vec3D posI) {
    type = "point";
    meshes[0] = create(new Vec3D(-pPointSize, 0, 0), new Vec3D(pPointSize, 0, 0), pPointSize);
    setTrans(new Vec3D(posI.x, posI.y, posI.z));
  }
}

class PPlate extends PMesh {
  public PPlate() {
    super();
    meshes[0] = create();
    type = "plate";
  }
}

class PTri extends PMesh {
  public PTri() {
    super();
    type = "tri";
    Vec3D a = new Vec3D(-1, 1, 0);
    Vec3D b = new Vec3D(-1, -1, 0);
    Vec3D c = new Vec3D(1, -1, 0);
    Vec3D d = new Vec3D((a.x + c.x)/2.0, (a.y + c.y)/2.0, (a.z + c.z)/2.0);
    meshes[0] = create(a, b, c, d);
    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult));
    setRandRot();
    //setTrans(new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }
}