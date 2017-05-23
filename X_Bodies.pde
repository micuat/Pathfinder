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
  sampleOriginBody = new Body(new PFace(new PVector(-0.5, 0.5, 0), new PVector(-0.5, -0.5, 0), new PVector(0.5, -0.5, 0), new PVector(0.5, 0.5, 0)));

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

  public void draw() {
    for (int i = 0; i < faces.length; i++)
      faces[i].draw();
  }

  void setTrans(PVector posI) {
    PVector pos = new PVector(posI.x, posI.y, posI.z);
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

  void setRot(PVector dir, float amount) {
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
    setTrans(new PVector(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }

  public PBox(float wI, float hI, float dI) {
    setup();
    setScale(wI, hI, dI);
  }

  public void setup() {
    type = "box";
    faces = new PFace[6];
    faces[0] = new PFace(new PVector( 1.0f, 1.0f, -1.0f), // Top Right Of The Quad (Top)
      new PVector(-1.0f, 1.0f, -1.0f), // Top Left Of The Quad (Top)
      new PVector(-1.0f, 1.0f, 1.0f), // Bottom Left Of The Quad (Top)
      new PVector( 1.0f, 1.0f, 1.0f));    // Bottom Right Of The Quad (Top)

    faces[1] = new PFace(new PVector( 1.0f, -1.0f, 1.0f), // Top Right Of The Quad (Bottom)
      new PVector(-1.0f, -1.0f, 1.0f), // Top Left Of The Quad (Bottom)
      new PVector(-1.0f, -1.0f, -1.0f), // Bottom Left Of The Quad (Bottom)
      new PVector( 1.0f, -1.0f, -1.0f));    // Bottom Right Of The Quad (Bottom)

    faces[2] = new PFace(new PVector( 1.0f, 1.0f, 1.0f), // Top Right Of The Quad (Front)
      new PVector(-1.0f, 1.0f, 1.0f), // Top Left Of The Quad (Front)
      new PVector(-1.0f, -1.0f, 1.0f), // Bottom Left Of The Quad (Front)
      new PVector( 1.0f, -1.0f, 1.0f));    // Bottom Right Of The Quad (Front)

    faces[3] = new PFace(new PVector( 1.0f, -1.0f, -1.0f), // Top Right Of The Quad (Back)
      new PVector(-1.0f, -1.0f, -1.0f), // Top Left Of The Quad (Back)
      new PVector(-1.0f, 1.0f, -1.0f), // Bottom Left Of The Quad (Back)
      new PVector( 1.0f, 1.0f, -1.0f));    // Bottom Right Of The Quad (Back)

    faces[4] = new PFace(new PVector(-1.0f, 1.0f, 1.0f), // Top Right Of The Quad (Left)
      new PVector(-1.0f, 1.0f, -1.0f), // Top Left Of The Quad (Left)
      new PVector(-1.0f, -1.0f, -1.0f), // Bottom Left Of The Quad (Left)
      new PVector(-1.0f, -1.0f, 1.0f));    // Bottom Right Of The Quad (Left)

    faces[5] = new PFace(new PVector( 1.0f, 1.0f, -1.0f), // Top Right Of The Quad (Right)
      new PVector( 1.0f, 1.0f, 1.0f), // Top Left Of The Quad (Right)
      new PVector( 1.0f, -1.0f, 1.0f), // Bottom Left Of The Quad (Right)
      new PVector( 1.0f, -1.0f, -1.0f));    // Bottom Right Of The Quad (Right)
  }
}

class PLine extends PMesh {
  public PLine() {
    super();
    type = "line";
    faces[0] = new PFace(new PVector(-1, 0, 0), new PVector(+1, 0, 0), 0.01);
    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), 1, 1);
    setRandRot();
    setTrans(new PVector(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }
}

static float pPointSize = 0.005;

class PPoint extends PMesh {
  public PPoint() {
    super();
    PVector posI = new PVector(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY));
    setup(posI);
  }
  public PPoint(PVector posI) {
    super();
    setup(posI);
  }

  void setup(PVector posI) {
    type = "point";
    faces[0] = new PFace(new PVector(-pPointSize, 0, 0), new PVector(pPointSize, 0, 0), pPointSize);
    setTrans(new PVector(posI.x, posI.y, posI.z));
  }
}

class PFace {
  PVector pos = new PVector(0, 0, 0);
  PVector[] vert = new PVector[4];
  float w = 1;
  float h = 1;
  float d = 1;

  public PFace() {
    vert[0] = new PVector(-1, 1, 0);
    vert[1] = new PVector(-1, -1, 0);
    vert[2] = new PVector(1, -1, 0);
    vert[3] = new PVector(1, 1, 0);

    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult));
    setRandRot();    
    PVector dim = getDimensions(); 
    setTrans(new PVector(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }

  public PFace(PVector a, PVector b, float heightV) {
    vert[0] = new PVector(a.x, a.y+heightV, a.z);
    vert[1] = new PVector(a.x, a.y-heightV, a.z);
    vert[2] = new PVector(b.x, b.y-heightV, b.z);
    vert[3] = new PVector(b.x, b.y+heightV, b.z);
  }

  public PFace(PVector a, PVector b, PVector c, PVector d) {
    vert[0] = new PVector(a.x, a.y, a.z);
    vert[1] = new PVector(b.x, b.y, b.z);
    vert[2] = new PVector(c.x, c.y, c.z);
    vert[3] = new PVector(d.x, d.y, d.z);
  }

  public PVector getDimensions() {

    float sX = 0;
    float sY = 0;
    float sZ = 0;

    for (int i = 0; i < vert.length; i++) {
      if (abs(vert[i].x) >= sX) sX = abs(vert[i].x);
      if (abs(vert[i].y) >= sY) sY = abs(vert[i].y);
      if (abs(vert[i].z) >= sZ) sZ = abs(vert[i].z);
    }
    return new PVector(sX, sY, sZ);
  }

  public void draw() {
    beginShape(QUAD);
    vertex(vert[0].x, vert[0].y, vert[0].z);
    vertex(vert[1].x, vert[1].y, vert[1].z);
    vertex(vert[2].x, vert[2].y, vert[2].z);
    vertex(vert[3].x, vert[3].y, vert[3].z);
    endShape();
  }

  void setRandRot() {
    if (!cp5QuantAnim)
      setRot(m.getRandVector(false), random(-1, 1) * PI / 2);
    else {
      setRot(m.getRandVector(true), (int)random(-2, 2) * PI / 2);
    }
  }
  void setRot(PVector dir, float amount) {
    vert = m.setPVectorRotation(vert, dir, amount);
  }

  void setTrans(PVector posI) {
    pos = new PVector(posI.x, posI.y, posI.z);
    if (cp5QuantAnim) pos = new PVector((int)posI.x, (int)posI.y, (int)posI.z);

    for (int j = 0; j < vert.length; j++) {
      vert[j].x += pos.x;
      vert[j].y += pos.y;
      vert[j].z += pos.z;
      if (!cp53DAnim) vert[j].z = 0;
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

    for (int j = 0; j < vert.length; j++) {
      vert[j].x *= w;
      vert[j].y *= h;
      vert[j].z *= d;
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
    PVector[] v = faces[0].vert;
    faces[0].vert[3] = new PVector((v[0].x + v[2].x)/2.0, (v[0].y + v[2].y)/2.0, (v[0].z + v[2].z)/2.0);
  }
}