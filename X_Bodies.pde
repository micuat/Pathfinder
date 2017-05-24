Body[] body = new Body[5];

Body sampleOriginBody;

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
  // TODO
  // won't work with:
  // sampleOriginBody = new Body(new PPlate());
  PPlate p = new PPlate();
  p.faces[0] = new PFace(new Vec3D(-0.5, 0.5, 0), new Vec3D(-0.5, -0.5, 0), new Vec3D(0.5, -0.5, 0), new Vec3D(0.5, 0.5, 0));
  sampleOriginBody = new Body(p);

  for (int i = 0; i < body.length; i++)
    getNextRandomBody(i);
}

int numRandomBody = 0;
void getNextRandomBody(int i) {
  if (i == 0) {
    body[0] = new Body(new PPoint());
  }
  if (i == 1) {
    body[1] = new Body(new PLine());
  }  
  if (i == 2) {
    body[2] = new Body(new PPlate());
  }
  if (i == 3) {
    body[3] = new Body(new PTri());
  }  
  if (i == 4) {
    if (!cp53DAnim)
      body[4] = new Body(new PPlate());
    else 
      body[4] = new Body(new PBox());
  }
  numRandomBody++;
  println(numRandomBody);
}

float globalScaleMult = 0.5;

class PMesh {
  String type;
  PFace[] faces;

  public PMesh() {
    type = "mesh";
    faces = new PFace[1];
    faces[0] = new PFace();
  }

  void setTrans(Vec3D posI) {
    Vec3D pos = new Vec3D(posI.x, posI.y, posI.z);
    for (int i = 0; i < faces.length; i++) {
      faces[i].setTrans(pos);
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
    for (int i = 0; i < faces.length; i++)
      faces[i].setRot(dir, amount);
  }

  void setScale(float wI, float hI, float dI) {
    for (int i = 0; i < faces.length; i++) {
      faces[i].setScale(wI, hI, dI);
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
    faces = new PFace[6];
    faces[0] = new PFace(new Vec3D( 1.0f, 1.0f, -1.0f), // Top Right Of The Quad (Top)
      new Vec3D(-1.0f, 1.0f, -1.0f), // Top Left Of The Quad (Top)
      new Vec3D(-1.0f, 1.0f, 1.0f), // Bottom Left Of The Quad (Top)
      new Vec3D( 1.0f, 1.0f, 1.0f));    // Bottom Right Of The Quad (Top)

    faces[1] = new PFace(new Vec3D( 1.0f, -1.0f, 1.0f), // Top Right Of The Quad (Bottom)
      new Vec3D(-1.0f, -1.0f, 1.0f), // Top Left Of The Quad (Bottom)
      new Vec3D(-1.0f, -1.0f, -1.0f), // Bottom Left Of The Quad (Bottom)
      new Vec3D( 1.0f, -1.0f, -1.0f));    // Bottom Right Of The Quad (Bottom)

    faces[2] = new PFace(new Vec3D( 1.0f, 1.0f, 1.0f), // Top Right Of The Quad (Front)
      new Vec3D(-1.0f, 1.0f, 1.0f), // Top Left Of The Quad (Front)
      new Vec3D(-1.0f, -1.0f, 1.0f), // Bottom Left Of The Quad (Front)
      new Vec3D( 1.0f, -1.0f, 1.0f));    // Bottom Right Of The Quad (Front)

    faces[3] = new PFace(new Vec3D( 1.0f, -1.0f, -1.0f), // Top Right Of The Quad (Back)
      new Vec3D(-1.0f, -1.0f, -1.0f), // Top Left Of The Quad (Back)
      new Vec3D(-1.0f, 1.0f, -1.0f), // Bottom Left Of The Quad (Back)
      new Vec3D( 1.0f, 1.0f, -1.0f));    // Bottom Right Of The Quad (Back)

    faces[4] = new PFace(new Vec3D(-1.0f, 1.0f, 1.0f), // Top Right Of The Quad (Left)
      new Vec3D(-1.0f, 1.0f, -1.0f), // Top Left Of The Quad (Left)
      new Vec3D(-1.0f, -1.0f, -1.0f), // Bottom Left Of The Quad (Left)
      new Vec3D(-1.0f, -1.0f, 1.0f));    // Bottom Right Of The Quad (Left)

    faces[5] = new PFace(new Vec3D( 1.0f, 1.0f, -1.0f), // Top Right Of The Quad (Right)
      new Vec3D( 1.0f, 1.0f, 1.0f), // Top Left Of The Quad (Right)
      new Vec3D( 1.0f, -1.0f, 1.0f), // Bottom Left Of The Quad (Right)
      new Vec3D( 1.0f, -1.0f, -1.0f));    // Bottom Right Of The Quad (Right)
  }
}

class PLine extends PMesh {
  public PLine() {
    super();
    type = "line";
    faces[0] = new PFace(new Vec3D(-1, 0, 0), new Vec3D(+1, 0, 0), 0.01);
    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), 1, 1);
    setRandRot();
    setTrans(new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }
}

static float pPointSize = 0.005;

class PPoint extends PMesh {
  public PPoint() {
    super();
    Vec3D posI = new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY));
    setup(posI);
  }
  public PPoint(Vec3D posI) {
    super();
    setup(posI);
  }

  void setup(Vec3D posI) {
    type = "point";
    faces[0] = new PFace(new Vec3D(-pPointSize, 0, 0), new Vec3D(pPointSize, 0, 0), pPointSize);
    setTrans(new Vec3D(posI.x, posI.y, posI.z));
  }
}

class PFace {
  WETriangleMesh meshI = new WETriangleMesh();

  Vec3D pos = new Vec3D(0, 0, 0);
  float w = 1;
  float h = 1;
  float d = 1;

  public PFace() {
    Vec3D a = new Vec3D(-1, 1, 0);
    Vec3D b = new Vec3D(-1, -1, 0);
    Vec3D c = new Vec3D(1, -1, 0);
    Vec3D d = new Vec3D(1, 1, 0);

    meshI.addFace(a, b, c);
    meshI.addFace(c, d, a);

    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult));
    setRandRot();    
    setTrans(new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }

  public PFace(Vec3D A, Vec3D B, float heightV) {
    Vec3D a = new Vec3D(A.x, A.y+heightV, A.z);
    Vec3D b = new Vec3D(A.x, A.y-heightV, A.z);
    Vec3D c = new Vec3D(B.x, B.y-heightV, B.z);
    Vec3D d = new Vec3D(B.x, B.y+heightV, B.z);

    meshI.addFace(a, b, c);
    meshI.addFace(c, d, a);
  }

  public PFace(Vec3D a, Vec3D b, Vec3D c, Vec3D d) {
    meshI.addFace(a, b, c);
    meshI.addFace(c, d, a);
  }

  void setRandRot() {
    if (!cp5QuantAnim)
      setRot(m.getRandVector(false), random(-1, 1) * PI / 2);
    else {
      setRot(m.getRandVector(true), (int)random(-2, 2) * PI / 2);
    }
  }
  void setRot(Vec3D dir, float amount) {
    for (int i = 0; i < meshI.getNumVertices(); i++) {
      meshI.getVertexForID(i).rotateAroundAxis(dir, amount);
    }
  }

  void setTrans(Vec3D posI) {
    pos = new Vec3D(posI.x, posI.y, posI.z);
    if (cp5QuantAnim) pos = new Vec3D((int)posI.x, (int)posI.y, (int)posI.z);

    for (int j = 0; j < meshI.getNumVertices(); j++) {
      meshI.getVertexForID(j).x += pos.x;
      meshI.getVertexForID(j).y += pos.y;
      meshI.getVertexForID(j).z += pos.z;
      if (!cp53DAnim) meshI.getVertexForID(j).z = 0;
    }
  }

  void setScale(float wI, float hI, float dI) {
    w = wI;
    h = hI;
    d = dI;

    if (cp5QuantAnim) {
      w = (int)w;
      h = (int)h;
      d = (int)d;
    }

    for (int j = 0; j < meshI.getNumVertices(); j++) {
      meshI.getVertexForID(j).x *= w;
      meshI.getVertexForID(j).y *= h;
      meshI.getVertexForID(j).z *= d;
    }
  }
}

class PPlate extends PMesh {
  public PPlate() {
    super();
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
    faces[0] = new PFace(a, b, c, d);
    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult));
    setRandRot();
    setTrans(new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }
}