Math m = new Math();

///////////////////////////////////////////////////////////////////////////////////////////
/////////////////THE Help//////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

class Math {

  public  Math() {
  }

  boolean compareMesh(WETriangleMesh src, WETriangleMesh dst) {
    Vec3D[] srcA = getVertexVec(src); 
    Vec3D[] srcB = getVertexVec(dst);

    boolean res = true;

    for (int i = 0; i < srcA.length; i++) {
      if (srcA[i].distanceTo(srcB[i]) > 0.1 ) res = false;
    }

    return res;
  }

  double getRotToTarget(WETriangleMesh src, WETriangleMesh dst) {
    double angle = 0;
    float[] vs = src.getUniqueVerticesAsArray();
    float[] vt = dst.getUniqueVerticesAsArray();


    Vec3D V1 = new Vec3D(vs[0] - vs[3], vs[1] - vs[4], vs[2] - vs[5]);
    V1 = V1.getNormalized();
    Vec3D V2 = new Vec3D(vt[0] - vt[3], vt[1] - vt[4], vt[2] - vt[5]);
    V2 = V2.getNormalized();

    angle = atan2(getNormal(dst).dot( V2.cross(V1)), V2.dot(V1));
    return angle;
  }

  Vec3D getCenter(WETriangleMesh src) {
    Vec3D center = src.computeCentroid();

    Vec3D[] v = getVertexVec(src);

    if (v.length>2) {
      center = new Vec3D( (v[0].x+v[2].x) / 2, (v[0].y+v[2].y) / 2, (v[0].z+v[2].z) / 2);
    }

    return center;
  }

  Vec3D getNormal(WETriangleMesh src) {
    Vec3D res = new Vec3D(0, 1, 0); 
    src.computeFaceNormals();
    float[] b = src.getFaceNormalsAsArray(null, 0, 0);
    if (b.length > 2)
      res = new Vec3D(b[0], b[1], b[2]);
    return res.getNormalized();
  }

  float getHeight(WETriangleMesh src) { 
    Vec3D[] t = getVertexVec(src);

    return t[0].distanceTo(t[1]);
  }

  float getWidth(WETriangleMesh src) {  
    Vec3D[] t = getVertexVec(src);

    return t[1].distanceTo(t[2]);
  }

  Vec3D[] getVertexVec(WETriangleMesh src) { 
    Vec3D[] res = new Vec3D[1];
    res[0] = new Vec3D(0, 0, 0);

    float[] vs = src.getUniqueVerticesAsArray();  

    int lng = vs.length;
    if (lng > 3) {
      res = new Vec3D[lng/3];
      for (int i = 0; i < lng; i+=3) {
        res[i/3] = new Vec3D(vs[i+0], vs[i+1], vs[i+2]);
      }
    }
    return res;
  }


  ///////////////////////////////////////////////////////////////////////////////////////////
  /////////////////THE Transfromation///////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////


  WETriangleMesh getRot(WETriangleMesh src, WETriangleMesh dst, float amount, int clapIndex) {
    WETriangleMesh mesh = src.copy();

    Vec3D tempA = getNormal(src);
    Vec3D tempB = getNormal(dst);

    Vec3D center = getCenter(mesh);
    mesh.translate(new Vec3D(-center.x, -center.y, -center.z));

    Vec3D rotVector = tempA.cross(tempB);
    rotVector.normalize();

    Vec3D[] offSetA = getVertexVec(mesh);

    if (rotVector.x == 0 && rotVector.y == 0 && rotVector.z == 0) {

      Vec3D diff = (offSetA[0].sub(offSetA[1])).normalize().abs();

      WETriangleMesh test = new WETriangleMesh();
      test.addFace(diff, tempA, tempB);

      rotVector = getNormal(test);
    } 

    float angleDiff = atan2(rotVector.dot( tempA.cross(tempB)), tempA.dot(tempB));

    angleDiff = radians(degrees(angleDiff) * amount);
    Vec3D  noTr = tempA.getRotatedAroundAxis(rotVector, angleDiff);  

    Vec3D offSet = new Vec3D(0, 0, 0); 
    if (clapIndex >= 0 && clapIndex < offSetA.length)
      offSet = offSetA[clapIndex];

    mesh.translate(new Vec3D(offSet.x, offSet.y, offSet.z));
    mesh.pointTowards(noTr.getNormalized(), tempA.getNormalized());
    mesh.translate(new Vec3D(-offSet.x, -offSet.y, -offSet.z));
    mesh.translate(center);

    return mesh;
  }

  void setRandRot(WETriangleMesh meshI) {
    if (!cp5QuantAnim)
      setRot(meshI, getRandVector(false), random(-1, 1) * PI / 2);
    else {
      setRot(meshI, getRandVector(true), (int)random(-2, 2) * PI / 2);
    }
  }

  void setRot(WETriangleMesh meshI, Vec3D dir, float amount) {
    meshI.rotateAroundAxis(dir, amount);
  }

  void setTrans(WETriangleMesh meshI, Vec3D posI) {
    if (cp5QuantAnim) posI = new Vec3D((int)posI.x, (int)posI.y, (int)posI.z);

    meshI.translate(posI);
    if (!cp53DAnim) setScale(meshI, 1, 1, 0);
  }

  void setScale(WETriangleMesh meshI, float w, float h, float d) {
    if (cp5QuantAnim) {
      w = (int)w;
      h = (int)h;
      d = (int)d;
    }

    Vec3D sc = new Vec3D(w, h, d);
    meshI.scale(sc);
  }

  Vec3D getRandVector(boolean quant) {
    Vec3D res = new Vec3D(0, 0, 1);

    if (!cp53DAnim)
      return new Vec3D (0, 0, 1);

    if (!quant) { 
      res = Vec3D.randomVector();
      res = res.normalize();
      return res;
    } else {
      int dir = (int)random(0, 2);
      if (dir == 0) res = new Vec3D(1, 0, 0);
      if (dir == 1) res = new Vec3D(0, 1, 0);
      return res;
    }
  }

  WETriangleMesh getRotNormal(WETriangleMesh src, WETriangleMesh dst, float amount) {

    WETriangleMesh mesh = new WETriangleMesh();
    mesh = src.copy(); 
    mesh = update(mesh);
    float rotAngleToTarget = (float)getRotToTarget(src, dst);

    Vec3D center = getCenter(mesh);
    mesh.translate(new Vec3D(-center.x, -center.y, -center.z)); 

    mesh.rotateAroundAxis(getNormal(mesh), (float)rotAngleToTarget * amount); 
    mesh.translate(center);
    return mesh;
  }

  WETriangleMesh update(WETriangleMesh src) {
    src.computeCentroid();
    src.computeFaceNormals();
    src.computeVertexNormals();

    return src;
  }


  boolean isTriangle(WETriangleMesh src) {
    Vec3D center = getCenter(src);

    Vec3D[] pos = getVertexVec(src); 

    float dist1 = pos[3].distanceTo(center);
    float dist2 = pos[0].distanceTo(center);

    if (dist1 < dist2 / 2)
      return true;
    else
      return false;
  }

  WETriangleMesh getTrans(WETriangleMesh src, WETriangleMesh dst, float amountX, float amountY, float amountZ) {
    WETriangleMesh mesh = new WETriangleMesh();
    mesh = src.copy();
    Vec3D cSrc = getCenter(src);
    Vec3D cDst = getCenter(dst);


    Vec3D tr = new Vec3D(cSrc.x + (cDst.x - cSrc.x) * amountX, cSrc.y + (cDst.y - cSrc.y) * amountY, cSrc.z + (cDst.z - cSrc.z) * amountZ);
    Vec3D centerN = getCenter(src);
    mesh.translate(tr.sub(centerN));

    return mesh;
  }
}



class TransformInfo {
  boolean rotAmount = true;
  boolean rotNormAmount = true;
  boolean transAmountX = true;
  boolean transAmountY = true;
  boolean transAmountZ = true;
  boolean sizeAmountX = true;
  boolean sizeAmountY = true;
  boolean triAmount = true;

  WETriangleMesh src; 
  WETriangleMesh dst;

  public TransformInfo() {
  }

  public TransformInfo(WETriangleMesh srcI, WETriangleMesh dstI) {
    src = srcI.copy();
    dst = dstI.copy();
  }

  public void enterMeshTransInfo(TransformInfo info) {
    rotAmount &= !info.rotAmount;
    rotNormAmount &= !info.rotNormAmount;
    transAmountX &= !info.transAmountX;
    transAmountY &= !info.transAmountY;
    transAmountZ &= !info.transAmountZ;
    sizeAmountX &= !info.sizeAmountX;
    sizeAmountY &= !info.sizeAmountY;
    triAmount &= !info.triAmount;
  }

  void invert() {
    rotAmount = !rotAmount;
    rotNormAmount = !rotNormAmount;
    transAmountX = !transAmountX;
    transAmountY = !transAmountY;
    transAmountZ = !transAmountZ;
    sizeAmountX = !sizeAmountX;
    sizeAmountY = !sizeAmountY;
    triAmount = !triAmount;
  }

  void calcMesh(Vec3D offSet) {
    checkPosition(offSet);
    checkSize();
    checkRot();
    checkRotNorm();
  }

  void checkPosition(Vec3D offSet) {
    Vec3D srcC = m.getCenter(src);
    Vec3D dstC = m.getCenter(dst).sub(offSet);    

    if (srcC.x == dstC.x && offSet.x == 0) transAmountX = false;
    if (srcC.y == dstC.y && offSet.y == 0) transAmountY = false;
    if (srcC.z == dstC.z && offSet.z == 0) transAmountZ = false;
  }

  void checkSize() {
    float heightSrc = m.getHeight(src);
    float heightDst = m.getHeight(dst);

    float widthSrc = m.getWidth(src);
    float widthDst = m.getWidth(dst);

    if (abs(widthSrc - widthDst) < pPointSize) sizeAmountX = false;
    if (abs(heightSrc - heightDst) < pPointSize) sizeAmountY = false;

    if (m.isTriangle(src) == m.isTriangle(dst))
      triAmount = false;
  }

  void checkRot() {
    Vec3D tempA = m.getNormal(src);
    Vec3D tempB = m.getNormal(dst);

    if (tempA.x == tempB.x && tempA.y == tempB.y && tempA.z == tempB.z)
      rotAmount = false;
  }

  void checkRotNorm() {
    if (m.getRotToTarget(src, dst) == 0)
      rotNormAmount = false;
  }
}