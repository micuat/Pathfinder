Item item;

ArrayList<MeshElement> elementCopy = new ArrayList<MeshElement>(0);
float rot1 = 0;
float rot2 = 0;

boolean enterRecording = true;

void enterBodyRecording(Body body, boolean insertLines) {

  boolean enter = false;
  if (rot1 == 0 && rot2 == 0) {
  } else {
    if (rot1 != choreo.aniRot || rot2 != choreo.aniRotNo) {
      enter = true;
    }
  }

  rot1 = choreo.aniRot;
  rot2 = choreo.aniRotNo;

  if (elementCopy.size() > 0 && elementCopy != null) {
    for (int i = 0; i < body.element.size() && i < elementCopy.size(); i++) {
      Vec3D[] pos = m.getVertexVec(body.element.get(i).mesh);
      Vec3D[] posCopy = m.getVertexVec(elementCopy.get(i).mesh);

      for (int j = 0; j < pos.length && j < posCopy.length; j++) {
        if (drawPointVsLines)
          item.enterEdge(pos[j], posCopy[j]);
        else {
          if (enter)
            item.enterEdge(pos[j], posCopy[j]);
          else
            item.enter(pos[j]);
        }
      }
    }
  }

  elementCopy = new ArrayList<MeshElement>(body.element.size());
  for (int i = 0; i < elementCopy.size(); i++)
    elementCopy.set(i, body.element.get(i).copy());
}

class Item {
  ArrayList<Vec3D> pos;
  ArrayList<Line> edges;

  public Item() {
    clear();
  }

  public void enter(Vec3D posI) {
    pos.add(0, posI);
  }

  public void enterEdge(Vec3D a, Vec3D b) {
    if (dist(a.x, a.y, a.z, b.x, b.y, b.z) < 2.5)
      edges.add(0, new Line(a, b, numRandomBody));
  }

  public void clear() {
    pos = new ArrayList<Vec3D>();
    edges = new ArrayList<Line>();
  }

  public void show(PGraphics in) {
    in.pushStyle();

    float s = min(6000, pos.size());
    for (int i = 1; i < s; i++) {
      in.pushMatrix();

      float freq = 1000;
      float perc = float(i % (int)freq) / freq;
      perc = perc * 2 * PI ;
      perc = 250 + 80 * sin(perc);

      in.stroke(perc, 107, (1 - (float)i / s) * 360, (1 - (float)i / s) * 360);
      in.strokeWeight(strokeWeightRecording * 1.2);
      in.translate(pos.get(i).x, pos.get(i).y, pos.get(i).z);
      in.point(0, 0, 0);
      in.popMatrix();
    }

    s = min(5000, edges.size());
    for (int i = 0; i < s; i++) {
      in.pushMatrix();
      in.strokeWeight(strokeWeightRecording / 4.0f * 3.0f);
      float freq = 1000;
      float perc = float(i % (int)freq) / freq;
      perc = perc * 2*PI ;
      perc = 258 + 50 * sin(perc);
      in.stroke(perc, 116, (1 - (float)i / s) * 360, (1 - (float)i / s) * 360);
      in.line(edges.get(i).a.x, edges.get(i).a.y, edges.get(i).a.z, edges.get(i).b.x, edges.get(i).b.y, edges.get(i).b.z);
      in.popMatrix();
    }
    in.popStyle();
  }

  public void writeToFile() {
    PrintWriter output = createWriter("recording" + "_" + day() + "_" + hour() + "_" + minute() + ".txt"); 
    for (Vec3D p : pos) output.println(p.x + "," + p.y + ","+p.z );
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
}  

class Line {
  PVector a = new PVector(0, 0, 0);  
  PVector b = new PVector(0, 0, 0); 
  int type = 0;
  float alpha = 1;

  public Line(PVector aI, PVector bI, int typeI) {
    a = new PVector(aI.x, aI.y, aI.z);
    b = new PVector(bI.x, bI.y, bI.z);
    type = typeI;
  }
  public Line(Vec3D aI, Vec3D bI, int typeI) {
    a = new PVector(aI.x, aI.y, aI.z);
    b = new PVector(bI.x, bI.y, bI.z);
    type = typeI;
  }

  public void decrease() {
    alpha = alpha - 0.05;
  }
}

class VisEdges {
  ArrayList<VisMesh> edges;
  public VisEdges() {
    edges = new ArrayList<VisMesh>();
  }

  public void enter(Body body, boolean frame) {
    if (body.element.size() < 30)
      edges.add(new VisMesh(body, frame));
  }

  public void update() {
    for (int i = edges.size() - 1; i >= 0; i--) {
      VisMesh edge = edges.get(i);
      if (edge.update()) {
        edges.remove(i);
      }
    }
  }

  public void draw(PGraphics in) {
    for (int i = edges.size() - 1; i >= 0; i--) {
      VisMesh edge = edges.get(i);
      edge.display(in);
    }
  }
}

class VisMesh {
  Body body;
  float x;
  float y;
  float z;

  float life = 1;

  boolean drawMesh;

  VisMesh(Body bodyI, boolean drawMeshI) {
    x = y = z = 0;

    body = bodyI;

    drawMesh = drawMeshI;
  }

  boolean update() {
    life -= 1.0f / 120.0f;
    if (life < 0) {
      return true;
    } else {
      return false;
    }
  }

  void display(PGraphics in) {
    for (int i = 0; i < body.element.size(); i++) {

      Vec3D[] pos = m.getVertexVec(body.element.get(i).mesh);

      if (cp5DisplayLast && drawMesh )
        drawPolyMesh(in, pos, color(360, 0), color(360, 360 * life), 1);

      int till = 0;
      if (m.isTriangle(body.element.get(i).mesh)) till = 1;
      if (pos.length > 3)
        for (int j = 0; j < pos.length - till; j++) {

          boolean draw = true;
          for (int t = 0; t < j; t++) {
            if (dist(pos[j].x, pos[j].y, pos[j].z, pos[t].x, pos[t].y, pos[t].z) == 0)
              draw = false;
          }
          if (draw) {
            in.pushStyle();
            in.pushMatrix();
            in.noFill();
            in.strokeWeight(strokeWeightPoints * 2);
            if (!drawMesh) in.strokeWeight(strokeWeightPoints);

            in.stroke(360, 360 * life);
            in.translate(pos[j].x, pos[j].y, pos[j].z);

            if (cp53DAnim) {
              float[] rota = cam.getRotations();

              in.rotateX(rota[0]);
              in.rotateY(rota[1] - globalRotate);
              in.rotateZ(rota[2]);
            }

            float s = cos (life * PI / 2) * 1.5;
            if (!drawMesh)
              s = s / 4.0f;

            in.ellipse(0, 0, s, s);
            in.popMatrix();
            in.popStyle();
          }
        }
    }
  }
}