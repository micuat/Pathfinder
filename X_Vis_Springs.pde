float RibbonHMouse = 0.028645834;
float RibbonSMouse = 0.33796296;

class Trails {
  Body cur;
  ArrayList <Ribbon> ribbons;
  int lastNum = 0;

  public Trails() {
    ribbons = new ArrayList<Ribbon>();
  }

  public void setup(Body transBody) {
    for (int i = 0; i < ribbons.size(); i++) {
      Ribbon rib;
      rib = ribbons.get(i);
      rib.kill = true;
    }

    for (int i = 0; i < transBody.element.length; i++) {
      Vec3D pos[] = m.getVertexVec(transBody.element[i].mesh);
      for (int j = 0; j < pos.length; j++) {
        Ribbon rib;

        rib = new Ribbon(new PVector(pos[j].x, pos[j].y, pos[j].z), 50, 8, 0.1, j);
        ribbons.add(rib);
      }
    }

    lastNum = transBody.element.length;
  }

  public void update(Body transBody) {
    int num = 0;
    for (int i = 0; i < transBody.element.length; i++) {
      Vec3D pos[] = m.getVertexVec(transBody.element[i].mesh); 

      for (int j = 0; j < pos.length; j++) {
        if (ribbons.size() > num ) {
          Ribbon rib = ribbons.get(num);  

          boolean remove = rib.update(pos[j].x, pos[j].y, pos[j].z);
          if (!remove)
            ribbons.remove(i);
          num++;
        }
      }
    }

    for (int i = num; i < ribbons.size(); i++) {
      Ribbon rib = ribbons.get(i);  

      boolean remove = rib.update();
      if (!remove)
        ribbons.remove(i);
    }
  }

  public void draw(PGraphics in) {
    in.pushMatrix();
    for (int i = 0; i < ribbons.size(); i++) {
      Ribbon rib = ribbons.get(i);
      rib.draw(in);
    }
    in.popMatrix();
  }
}

class Ribbon {
  float killTime = 1;
  boolean kill = false;
  float killSpeed = 0.01;

  boolean pause = false;
  int index =0;

  int totalNodes = 100;
  Node[] node;

  float x, xT, xDist, xInc;
  float y, yT, yDist, yInc;
  float z, zT, zDist, zInc;

  float rads, rads2;

  float decay;

  float accel;
  float friction;

  float radius;
  float initRot;
  float rotSpeed;

  float counter;

  int fillColor;
  int strokeColor;

  float hh;
  float ss;
  float bb;
  float aa;

  Ribbon(PVector pos, int totalNodes, float radius, float decay, int index) {
    this.index = index;
    this.totalNodes = totalNodes;
    this.radius = radius;
    this.decay = decay;

    xT = x = pos.x;
    yT = y = pos.y;
    zT = z = pos.z;
    node = new Node[totalNodes];
    node[0] = new Node(0, pos.x, pos.y, pos.z, this);

    for (int i = 1; i < totalNodes; i++) {
      node[i] = new Node(i, node[i-1], this);
    }

    accel     = 2;
    friction  = 0.3;

    initRot   = PI;
    rotSpeed  = 0.1;

    counter   = PI;
  }

  boolean update() {
    return update(xT, yT, zT);
  }

  boolean update(float x, float y, float z) {
    xT = x;
    yT = y;
    zT = z;

    if (!pause) {
      for (int i = 0; i < totalNodes; i++) {
        node[i].exist();
      }
      findPosition(x, y, z);
    }

    killTime=killTime - ((kill)? killSpeed : 0);

    if (killTime > 0)
      return true;
    else
      return false;
  }

  void findPosition(float xI, float yI, float zI) {
    xDist   = xI - x;
    yDist   = yI - y;
    zDist   = zI - z;
    xInc    = (xDist / accel + xInc) * friction;
    yInc    = (yDist / accel + yInc) * friction;
    zInc    = (zDist / accel + zInc) * friction;
    x += xInc;
    y += yInc;
    z += zInc;
  }

  void draw(PGraphics in) {
    in.noStroke();
    in.pushStyle();
    in.blendMode(BLEND);
    in.hint(DISABLE_DEPTH_TEST);
    in.beginShape(QUAD_STRIP);

    for (int i = 1; i < totalNodes; i++) {
      rads  = abs(sin(getRadians(node[i].getX(), node[i].getY(), node[i-1].getX(), node[i-1].getY())));
      rads2 = abs(sin(getRadians(node[i].getX(), node[i].getY(), node[i].orbit.getX(), node[i].orbit.getY())));

      hh = 360 * RibbonHMouse + abs(rads - rads2) * 3;

      ss = 360 * RibbonSMouse + abs(rads - rads2) * 10.0f;
      ss = constrain(ss, 0, 360);
      bb = 200 + abs(rads2 - rads) * 160.0f;
      bb = constrain(bb, 200, 360);

      float lerp = (1 - (float)i / (float)totalNodes);
      lerp = min(1, max(0, lerp));

      float val = sin(PI/2 * (1 - (float)i / (float)totalNodes));
      val = pow(val, 6);
      val = val / 2.0;

      in.fill(hh, ss, bb, 360.0 * val * killTime);

      in.vertex(node[i].orbit.getX(), node[i].orbit.getY(), node[i].orbit.getZ());
      in.vertex(node[i].getX(), node[i].getY(), node[i].getZ());
    }
    in.endShape();
    in.popStyle();
  }

  float getRadians(float x1, float y1, float x2, float y2) {
    float xd = x1 - x2;
    float yd = y1 - y2;

    float rads = atan2(yd, xd);
    return rads;
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  float getZ() {
    return z;
  }
}

class Orbit {
  Node n;
  Ribbon r;

  int index;

  float x;
  float y;
  float z;

  float counter;
  float aug;

  PApplet p;

  Orbit(Ribbon rSent, Node nSent, int indexSent) {
    n = nSent;
    r = rSent;
    x = n.x;
    y = n.y;
    z = n.z;
    index   = indexSent;
    counter = r.initRot + index / 158.0f;
    aug     = r.rotSpeed;
  }

  void exist() {
    findPosition();
    counter += aug;
  }

  void findPosition() {
    float spike = 1;
    if (index < 100) {
      spike = (0.01f * index);
    }
    float noiseVal = noise(x / 100.0, y / 100.0, z / 100.0) - 0.5;
    x = n.getX() + p.sin(noiseVal) * (r.radius - index/50.0f)*spike; 
    y = n.getY() + p.sin(noiseVal) * (r.radius - index/50.0f)*spike;
    z = n.getZ() + (p.sin(noiseVal) * (r.radius - index/50.0f)*spike);
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  float getZ() {
    return z;
  }
}


class Node {
  Ribbon r;
  Node n;

  Orbit orbit;
  int index;

  float decay;

  float x;
  float y;
  float z;

  boolean isFirst;

  Node(int indexSent, float xSent, float ySent, float zSent, Ribbon rSent) {
    isFirst = true;
    init(xSent, ySent, zSent, indexSent, rSent);
  }

  Node(int indexSent, Node nSent, Ribbon rSent) {
    isFirst = false;
    n       = nSent;
    init(n.x, n.y, n.z, indexSent, rSent);
  }

  void init(float xSent, float ySent, float zSent, int indexSent, Ribbon rSent) {
    index = indexSent;
    r     = rSent;
    x     = xSent;
    y     = ySent;
    z     = zSent;

    orbit = new Orbit(r, this, index);
  }

  void exist() {
    findPosition();
    orbit.exist();
  }

  void findPosition() {
    if (isFirst) {
      x = r.getX();
      y = r.getY();
      z = r.getZ();
    } else {
      x -= (x - n.getX()) * r.decay;
      y -= (y - n.getY()) * r.decay;
      z -= (z - n.getZ()) * r.decay;

      //hole Band for each node____________
      float noiseVal  = noise(x / 10.0, y / 10.0, (float)frameCount / 100.0) - 0.5;
      float noiseVal2 = noise(x / 10.0, y / 10.0, (float)frameCount / 100.1) - 0.5;
      float noiseVal3 = noise(x / 10.0, y / 10.0, (float)frameCount / 100.2) - 0.5;
      x += noiseVal  / 200.0;
      y += noiseVal2 / 200.0;
      z += noiseVal3 / 200.0;
    }
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  float getZ() {
    return z;
  }

  void setX(float xSent) {
    x = xSent;
  }

  void setY(float ySent) {
    y = ySent;
  }

  void setZ(float zSent) {
    z = zSent;
  }
}