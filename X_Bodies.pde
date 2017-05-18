OBJModel[] kinModel = new OBJModel[2];
Body [] body = new Body[5];

Body sampleOriginBody;

/*
int[] listofBody = {
 0, 2, 1, 3, 1, 0, 3, 2
 };*/


int[] listofBody = {
  0, 1, 2, 3
};

/*
int[] listofBody = {
 4, 3,4,2
 };*/

/*
int[] listofBody = {
 2, 1, 3, 2, 1, 0, 3, 1
 };
 
 
/*
 int[] listofBody = {
 0, 2, 0, 2, 0, 2, 0, 2
 };*/


String[] nameofBody = {
  "Point", "Line", "Plate", "Triangle", "Box"
};

int calcRandomValue(int from, int to) {
  int val= (int)random(from, to+1);

  return constrain(val, from, to);
} 

int calcRandomValue(float from, float to) {
  float val= (int)random(from, to+1);

  return (int)constrain(val, from, to);
} 


void setupBodyPrimitives() {

  sampleOriginBody=new Body(new PFace(new PVector(-0.5, 0.5, 0), new PVector(-0.5, -0.5, 0), new PVector(0.5, -0.5, 0), new PVector(0.5, 0.5, 0)));

  for (int i=0; i < body.length; i++) getNextRandomBody(i);
}




int numRandomBody = 0;
void getNextRandomBody(int i) {
  if (i==0) {
    body[0]=new Body(new PPoint().face);
  }
  if (i==1) {

    body[1]=new Body(new PLine().face);//(new PVector(2, -1, 0), new PVector(3, 0, 0)).face);
  }  
  if (i==2) {   
    body[2]=new Body(new PFace());
  }
  if (i==3) {
    body[3]=new Body(new PTri());
  }  
  if (i==4) {
    if (!cp53DAnim) body[4]=new Body(new PFace());
    else 
    body[4]=new Body(new PBox().face);
  }
  numRandomBody++;
  println(numRandomBody);
}






float globalScaleMult=0.5;
class PBox {
  PFace[] face = new PFace[6];

  float w, h, d = 1;
  PVector pos=new PVector(0, 0, 0);



  public PBox() {
    setup();

    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult));
    setRandRot();
    // setTrans(new PVector((int)random(-cp5WorldRangeX, cp5WorldRangeX), (int)random(-cp5WorldRangeY, cp5WorldRangeY), (int)random(-cp5WorldRangeY, cp5WorldRangeY)));
    setTrans(new PVector(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }

  public PBox(float wI, float hI, float dI) {
    setup();
    setScale(wI, hI, dI);
  }

  void setTrans(PVector posI) {
    pos=new PVector(posI.x, posI.y, posI.z);
    for (int i=0; i < face.length; i++) {
      face[i].setTrans(pos);
    }
  }




  void setRandRot() {
    if (!cp5QuantAnim) setRot(m.getRandVector(false), random(-1, 1)*PI/2);
    else {    
      setRot(m.getRandVector(true), (int)random(-2, 2)*PI/2);
    }
  }


  void setRot(PVector dir, float amount) {
    for (int i=0; i < face.length; i++)
      face[i].setRot(dir, amount);
  }


  void setScale(float wI, float hI, float dI) {
    w=wI;
    h=hI;
    d=dI;
    for (int i=0; i < face.length; i++) {
      face[i].setScale(w, h, d);
    }
  }


  public void setup() {
    face[0] = new PFace(new PVector( 1.0f, 1.0f, -1.0f), // Top Right Of The Quad (Top)
      new PVector(-1.0f, 1.0f, -1.0f), // Top Left Of The Quad (Top)
      new PVector(-1.0f, 1.0f, 1.0f), // Bottom Left Of The Quad (Top)
      new PVector( 1.0f, 1.0f, 1.0f));    // Bottom Right Of The Quad (Top)

    face[1] = new PFace(new PVector( 1.0f, -1.0f, 1.0f), // Top Right Of The Quad (Bottom)
      new PVector(-1.0f, -1.0f, 1.0f), // Top Left Of The Quad (Bottom)
      new PVector(-1.0f, -1.0f, -1.0f), // Bottom Left Of The Quad (Bottom)
      new PVector( 1.0f, -1.0f, -1.0f));    // Bottom Right Of The Quad (Bottom)

    face[2] = new PFace(new PVector( 1.0f, 1.0f, 1.0f), // Top Right Of The Quad (Front)
      new PVector(-1.0f, 1.0f, 1.0f), // Top Left Of The Quad (Front)
      new PVector(-1.0f, -1.0f, 1.0f), // Bottom Left Of The Quad (Front)
      new PVector( 1.0f, -1.0f, 1.0f));    // Bottom Right Of The Quad (Front)

    face[3] = new PFace(new PVector( 1.0f, -1.0f, -1.0f), // Top Right Of The Quad (Back)
      new PVector(-1.0f, -1.0f, -1.0f), // Top Left Of The Quad (Back)
      new PVector(-1.0f, 1.0f, -1.0f), // Bottom Left Of The Quad (Back)
      new PVector( 1.0f, 1.0f, -1.0f));    // Bottom Right Of The Quad (Back)

    face[4] = new PFace(new PVector(-1.0f, 1.0f, 1.0f), // Top Right Of The Quad (Left)
      new PVector(-1.0f, 1.0f, -1.0f), // Top Left Of The Quad (Left)
      new PVector(-1.0f, -1.0f, -1.0f), // Bottom Left Of The Quad (Left)
      new PVector(-1.0f, -1.0f, 1.0f));    // Bottom Right Of The Quad (Left)

    face[5] = new PFace(new PVector( 1.0f, 1.0f, -1.0f), // Top Right Of The Quad (Right)
      new PVector( 1.0f, 1.0f, 1.0f), // Top Left Of The Quad (Right)
      new PVector( 1.0f, -1.0f, 1.0f), // Bottom Left Of The Quad (Right)
      new PVector( 1.0f, -1.0f, -1.0f));    // Bottom Right Of The Quad (Right)
  }

  public void draw() {
    for (int i=0; i <face.length; i++)
      face[i].draw();
  }
}

class PLine {

  PFace face;

  public PLine() {

    face = new PFace(new PVector(-1, 0, 0), new PVector(+1, 0, 0), 0.01);
    face.vert[0] = new PVector(-1, 0.01, 0);
    face.vert[1] = new PVector(-1, -0.01, 0);
    face.vert[2] = new PVector(1, -0.01, 0);
    face.vert[3] = new PVector(1, 0.01, 0);
    face.setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), 1, 1);
    face.setRandRot();
    // face.setTrans(new PVector(random(-cp5WorldRangeX, cp5WorldRangeX), random(-cp5WorldRangeY, cp5WorldRangeY), random(-cp5WorldRangeY, cp5WorldRangeY)));
    face.setTrans(new PVector(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }
}

static float pPointSize=0.005;


class PPoint {
  PFace face;
  PVector pos=new PVector(0, 0, 0);

  public PPoint() {
    setup();
    // face.setTrans(new PVector(random(-cp5WorldRangeX, cp5WorldRangeX), random(-cp5WorldRangeY, cp5WorldRangeY), random(-cp5WorldRangeY, cp5WorldRangeY)));
    face.setTrans(new PVector(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
  }
  public PPoint(PVector posI) {
    setup();
    pos=posI;
    face.setTrans(new PVector(pos.x, pos.y, pos.z));
  }


  public void setup() {
    face =  new PFace(new PVector(-pPointSize, 0, 0), new PVector(pPointSize, 0, 0), pPointSize);
  }
}



class PFace {
  PVector pos=new PVector(0, 0, 0);
  PVector[] vert = new PVector[4];
  float w=1;
  float h=1;
  float d=1;

  public PFace() {

    vert[0] = new PVector(-1, 1, 0);
    vert[1] = new PVector(-1, -1, 0);
    vert[2] = new PVector(1, -1, 0);
    vert[3] = new PVector(1, 1, 0);

    setScale(calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult), calcRandomValue(1, cp5WorldRangeY*globalScaleMult));
    setRandRot();    
    PVector dim = getDimensions(); 
    //  setTrans(new PVector(random(-cp5WorldRangeX, cp5WorldRangeX), random(-cp5WorldRangeY, cp5WorldRangeY), random(-cp5WorldRangeY, cp5WorldRangeY)  ) );
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

    float sX=0;
    float  sY=0;
    float sZ=0;

    for (int i=0; i < vert.length; i++) {

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

    // println("check this one " + m.getRandVector(true));

    if (!cp5QuantAnim) setRot(m.getRandVector(false), random(-1, 1)*PI/2);
    else {

      setRot(m.getRandVector(true), (int)random(-2, 2)*PI/2);
    }
  }
  void setRot(PVector dir, float amount) {
    vert = m.setPVectorRotation(vert, dir, amount);
  }


  void setTrans(PVector posI) {
    pos=new PVector(posI.x, posI.y, posI.z);
    if (cp5QuantAnim) pos=new PVector((int)posI.x, (int)posI.y, (int)posI.z);

    for (int j=0; j < vert.length; j++) {
      vert[j].x+=pos.x;
      vert[j].y+=pos.y;      
      vert[j].z+=pos.z;
      if (!cp53DAnim) vert[j].z=0;
    }
  }



  void setScale(float wI, float hI, float dI) {

    w=wI;
    h=hI;
    d=dI;

    if (cp5QuantAnim) {
      w=(int)w;
      h=(int)h;
      d=(int)d;
    }

    for (int j=0; j < vert.length; j++) {
      vert[j].x*=w;
      vert[j].y*=h;
      vert[j].z*=d;
    }
  }
}



class PTri extends PFace {

  public PTri() {
    super();    
    vert[3] = new PVector((vert[0].x + vert[2].x)/2.0, (vert[0].y + vert[2].y)/2.0, (vert[0].z + vert[2].z)/2.0);
  }
}