int showDebugVertNum = 0;
boolean drawDebug = true;

void drawWorld(PGraphics in) {

  if (cp5WorldOrigin) {
    in.pushStyle();
    in.noFill();
    in.strokeWeight(strokeWeightObjects);
    in.stroke(highlight1);

    if (cp53DAnim) {
      in.line(0, 0, 0, cp5WorldRangeX, 0, 0);
      in.line(0, 0, 0, 0, -cp5WorldRangeY, 0);
      in.line(0, 0, 0, 0, 0, cp5WorldRangeY);
    } else {
      in.ellipse(0, 0, 0.5, 0.5);
    }
    in.popStyle();
  }

  if (cp5WorldRoom) {
    in.pushStyle();
    in.strokeWeight(strokeWeightObjects);
    in.noFill();
    in.stroke(highlight2);
    if (cp53DAnim)
      in.box(cp5WorldRangeX * 2, cp5WorldRangeY * 2, cp5WorldRangeY * 2);
    else {
      in.rectMode(CENTER);
      in.rect(0, 0, cp5WorldRangeX * 2, cp5WorldRangeY * 2);
    }
    in.popStyle();
  }

  if (cp5WorldGrid) {
    in.pushStyle();
    in.strokeWeight(strokeWeightObjects / 4.0f * 3.0f);
    in.stroke(highlight2, 150);

    if (cp53DAnim) {
      if (cp5WorldRoom)
        in.strokeWeight(strokeWeightObjects / 2.0f);
      else 
      in.strokeWeight(strokeWeightObjects);

      for (int i = -cp5WorldRangeX; i < cp5WorldRangeX + 1; i+=1)
        in.line(i, cp5WorldRangeY, -cp5WorldRangeY, i, cp5WorldRangeY, cp5WorldRangeY);
      for (int i = -cp5WorldRangeY; i < cp5WorldRangeY + 1; i+=1)
        in.line(-cp5WorldRangeX, cp5WorldRangeY, i, cp5WorldRangeX, cp5WorldRangeY, i);
    } else {
      for (int i = -(cp5WorldRangeX - 1); i < cp5WorldRangeX; i+=1) {
        for (int j = -(cp5WorldRangeY - 1); j < cp5WorldRangeY; j+=1) {
          in.stroke(highlight2);

          in.pushMatrix();
          float len = 0.2;
          in.translate(i, j, 0);
          in.line(-len, 0, 0, len, 0, 0);
          in.line(0, -len, 0, 0, len, 0);
          in.popMatrix();
        }
      }
    }
    in.popStyle();
  }
}

void drawHUD() {
  drawGui();
  pushStyle();
  pushMatrix();
  strokeWeight(8);
  stroke(255, 30);
  translate(width - 275, unitSpace * 30);

  int yUnit = 25;
  int xLength = 100;

  for (int i = 0; i < choreo.toDoTasks.length; i++) {
    stroke(255, 30);
    line (100, i * yUnit - 5, 100 + xLength, i * yUnit - 5);
    stroke(360);
    fill(360);
    if (choreo.toDoTasks[i].equals("aniRot")) {
      pushMatrix();
      text("Rot ", 0, i * yUnit);
      translate(100, -5);
      line(0, i * yUnit, xLength*choreo.aniRot / 100.0, i * yUnit);
      popMatrix();
    }

    if (choreo.toDoTasks[i].equals("aniRotNo")) {
      pushMatrix();
      text("Rot No ", 0, i * yUnit);
      translate(100, -5);
      line(0, i * yUnit, xLength * choreo.aniRotNo / 100.0, i * yUnit);
      popMatrix();
    }

    if (choreo.toDoTasks[i].equals("aniTransX")) {
      pushMatrix();
      text("Trans X ", 0, i * yUnit);
      translate(100, -5);
      line(0, i * yUnit, xLength * choreo.aniTransX / 100.0, i * yUnit);
      popMatrix();
    }

    if (choreo.toDoTasks[i].equals("aniTransY")) {
      pushMatrix();
      text("Trans Y ", 0, i * yUnit);
      translate(100, -5);
      line(0, i * yUnit, xLength * choreo.aniTransY / 100.0, i * yUnit);
      popMatrix();
    }

    if (choreo.toDoTasks[i].equals("aniTransZ")) {
      pushMatrix();
      text("Trans Z ", 0, i * yUnit);
      translate(100, -5);
      line(0, i * yUnit, xLength * choreo.aniTransZ / 100.0, i * yUnit);
      popMatrix();
    }

    if (choreo.toDoTasks[i].equals("aniSizeX")) {
      pushMatrix();
      text("Scale X ", 0, i * yUnit);
      translate(100, -5);
      line(0, i * yUnit, xLength * choreo.aniSizeX / 100.0, i * yUnit);
      popMatrix();
    }

    if (choreo.toDoTasks[i].equals("aniSizeY")) {
      pushMatrix();
      text("Scale Y ", 0, i*yUnit);
      translate(100, -5);
      line(0, i * yUnit, xLength * choreo.aniSizeY / 100.0, i * yUnit);
      popMatrix();
    }

    if (choreo.toDoTasks[i].equals("aniTri")) {
      pushMatrix();
      text("Tri Deform ", 0, i * yUnit);
      translate(100, -5);
      line(0, i * yUnit, xLength * choreo.aniTri / 100.0, i * yUnit);
      popMatrix();
    }
  }

  popMatrix();
  popStyle();
}

void drawBody(PGraphics in, Body body, color colorFill, color colorStroke) {
  for (int i = 0; i < body.element.size(); i++) {
    drawMesh(in, body.element.get(i).mesh, colorFill, colorStroke);
  }
}


void drawMesh(PGraphics in, WETriangleMesh meshI, color colorFill, color colorStroke) {
  in.pushMatrix();
  in.pushStyle();
  float[] norm = meshI.getVertexNormalsAsArray();
  Vec3D center = meshI.computeCentroid(); 
  Vec3D[] pos = m.getVertexVec(meshI);

  in.stroke(colorStroke);
  in.strokeWeight(1);

  if (pos.length > 3) {
    if (cp5DisplayPolygon) {
      drawPolyMesh(in, pos, colorFill, colorStroke, 1);
    }

    if (cp5DisplayLines) {
      in.pushStyle();
      in.noFill();
      in.strokeWeight(strokeWeightObjects);
      in.stroke(colorStroke);
      in.beginShape(POLYGON);
      in.vertex(pos[0].x, pos[0].y, pos[0].z, 0, 0);
      in.vertex(pos[1].x, pos[1].y, pos[1].z, 0, 1);
      in.vertex(pos[2].x, pos[2].y, pos[2].z, 1, 1);
      in.vertex(pos[3].x, pos[3].y, pos[3].z, 1, 0);
      in.vertex(pos[0].x, pos[0].y, pos[0].z, 1, 0);
      in.endShape();
      in.popStyle();
    }

    if (cp5DisplayPoints) {
      in.pushStyle();
      in.stroke(highlight2);
      in.strokeWeight(strokeWeightTrails * 4);
      in.point(pos[0].x, pos[0].y, pos[0].z);
      in.point(pos[1].x, pos[1].y, pos[1].z);
      in.point(pos[2].x, pos[2].y, pos[2].z);
      in.point(pos[3].x, pos[3].y, pos[3].z);
      in.popStyle();
    }

    if (cp5DisplayNormals) {
      in.pushStyle();
      in.colorMode(RGB);
      in.stroke( abs(norm[0]) * 255, abs(norm[1]) * 255, abs(norm[2]) * 255);
      in.line(center.x + norm[0] / 3, center.y + norm[1] / 3, center.z + norm[2] / 3, center.x, center.y, center.z); 
      in.popStyle();
    }

    if (cp5DisplayTrails)
      trails.draw(in);
  }

  in.popStyle();
  in.popMatrix();
}

void drawPolyMesh(PGraphics in, WETriangleMesh meshI, color fillCol, color strokeCol, float strokeWeightI) {
  Vec3D[] pos = m.getVertexVec(meshI);

  if (pos.length > 3) {
    drawPolyMesh(in, pos, fillCol, strokeCol, strokeWeightI);
  }
}

void drawPolyMesh(PGraphics in, Vec3D [] pos, color fillCol, color strokeCol, float strokeWeightI) {
  if (pos.length > 3) {
    in.strokeWeight(strokeWeightI);
    in.stroke(strokeCol);
    in.fill(fillCol);
    in.noFill();
    in.beginShape(POLYGON);
    in.vertex(pos[0].x, pos[0].y, pos[0].z);
    in.vertex(pos[1].x, pos[1].y, pos[1].z);
    in.vertex(pos[2].x, pos[2].y, pos[2].z);
    vertex(pos[3].x, pos[3].y, pos[3].z);
    vertex(pos[0].x, pos[0].y, pos[0].z);
    endShape();
  }
}