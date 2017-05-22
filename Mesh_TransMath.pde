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

  boolean compareNormal(WETriangleMesh src, WETriangleMesh dst) {
    Vec3D a = getNormal(src);
    Vec3D b = getNormal(dst);

    return compareVector(a, b);
  }

  boolean compareVector(Vec3D a, Vec3D b) {
    return a.equalsWithTolerance(b, 0.01);
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

  Vec3D getFaceTowards(WETriangleMesh src) { 
    Vec3D res = new Vec3D(0, 1, 0);  
    float[] vs = src.getUniqueVerticesAsArray();
    res = new Vec3D(vs[0] - vs[3], vs[1] - vs[4], vs[2] - vs[5]);
    return res.getNormalized();
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
    WETriangleMesh mesh = new WETriangleMesh();
    mesh = src.copy();  

    Vec3D tempA = getNormal(src);
    Vec3D tempB = getNormal(dst);

    Vec3D center = getCenter(mesh);//mesh.computeCentroid();
    mesh.translate(new Vec3D(-center.x, -center.y, -center.z));    

    Vec3D rotVector = (tempA.cross(tempB)); 
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

  PVector[] setPVectorRotation(PVector[] face, PVector dir, float rot) {

    for (int i = 0; i < face.length; i++) {
      Vec3D res = new Vec3D(face[i].x, face[i].y, face[i].z);
      res = res.getRotatedAroundAxis(new Vec3D(dir.x, dir.y, dir.z), rot);
      face[i] = new PVector(res.x, res.y, res.z);
    }

    return face;
  }

  PVector getRandVector(boolean quant) {
    Vec3D res = new Vec3D(0, 0, 1);

    if (!cp53DAnim)
      return new PVector (0, 0, 1);

    if (!quant) { 
      res = new Vec3D(1, 1, 1).randomVector();
      res = res.normalize();
      return new PVector(res.x, res.y, res.z);
    } else {
      int dir = (int)random(0, 2);
      if (dir == 0) res = new Vec3D(1, 0, 0);
      if (dir == 1) res = new Vec3D(0, 1, 0);
      return new PVector(res.x, res.y, res.z);
    }
  }

  PVector setPVectorRotation(PVector face, PVector dir, float rot) {
    PVector resP = new PVector(0, 0, 0);

    Vec3D res = new Vec3D(face.x, face.y, face.z);
    res = res.getRotatedAroundAxis(new Vec3D(dir.x, dir.y, dir.z), rot);
    resP = new PVector(res.x, res.y, res.z);

    return resP;
  }

  WETriangleMesh getRotNormal(WETriangleMesh src, WETriangleMesh dst, float amount) {

    WETriangleMesh mesh = new WETriangleMesh();
    mesh = src.copy(); 
    mesh = update(mesh);
    float rotAngleToTarget = (float)getRotToTarget(src, dst);

    Vec3D center = getCenter(mesh);
    mesh.translate(new Vec3D(-center.x, -center.y, -center.z)); 

    Vec3D memNormal = getNormal(mesh);

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

  WETriangleMesh getTrans(WETriangleMesh src, WETriangleMesh dst, float amountX, float amountY, float amountZ, Vec3D offSet) {
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
  float rotAmount = 1;
  float rotNormAmount = 1;
  float transAmountX = 1;
  float transAmountY = 1;
  float transAmountZ = 1;
  float sizeAmountX = 1;
  float sizeAmountY = 1;
  float triAmount = 1;

  WETriangleMesh src; 
  WETriangleMesh dst;

  public TransformInfo() {
  }

  public TransformInfo(WETriangleMesh srcI, WETriangleMesh dstI) {
    src = srcI.copy();
    dst = dstI.copy();
  }

  public void enterMeshTransInfo(TransformInfo info) {
    rotAmount *= abs(info.rotAmount - 1);
    rotNormAmount *= abs(info.rotNormAmount - 1);
    transAmountX *= abs(info.transAmountX - 1);
    transAmountY *= abs(info.transAmountY - 1);
    transAmountZ *= abs(info.transAmountZ - 1);
    sizeAmountX *= abs(info.sizeAmountX - 1);
    sizeAmountY *= abs(info.sizeAmountY - 1);
    triAmount *= abs(info.triAmount - 1);
  }

  void invert() {
    rotAmount = abs(rotAmount - 1);
    rotNormAmount = abs(rotNormAmount - 1);
    transAmountX = abs(transAmountX - 1);
    transAmountY = abs(transAmountY - 1);
    transAmountZ = abs(transAmountZ - 1);
    sizeAmountX = abs(sizeAmountX - 1);
    sizeAmountY = abs(sizeAmountY - 1);
    triAmount = abs(triAmount - 1);
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

    if (srcC.x == dstC.x && offSet.x == 0) transAmountX = 0;
    if (srcC.y == dstC.y && offSet.y == 0) transAmountY = 0;
    if (srcC.z == dstC.z && offSet.z == 0) transAmountZ = 0;
  }

  void checkSize() {
    float heightSrc = m.getHeight(src);
    float heightDst = m.getHeight(dst);

    float widthSrc = m.getWidth(src);
    float widthDst = m.getWidth(dst);

    if (abs(widthSrc - widthDst) < pPointSize) sizeAmountX = 0;
    if (abs(heightSrc - heightDst) < pPointSize) sizeAmountY = 0;

    Vec3D[] verts = m.getVertexVec(src);
    Vec3D[] vertsT = m.getVertexVec(dst);

    if (m.isTriangle(src) == m.isTriangle(dst))
      triAmount = 0;
  }

  void checkRot() {
    Vec3D tempA = m.getNormal(src);
    Vec3D tempB = m.getNormal(dst);

    if (tempA.x == tempB.x && tempA.y == tempB.y && tempA.z == tempB.z)
      rotAmount = 0;
  }

  void checkRotNorm() {
    if (m.getRotToTarget(src, dst) == 0)
      rotNormAmount = 0;
  }

  void printIt() {
    print(" rotAmount " + rotAmount);
    print(" - rotNormAmount " + rotNormAmount);
    print(" - transAmountX " + transAmountX);
    print(" - transAmountY " + transAmountY);
    print(" - transAmountZ " + transAmountZ);
    print(" - sizeAmountX " + sizeAmountX);
    print(" - sizeAmountY " + sizeAmountY);
    print(" - triAmount " + triAmount);
    println();
  }
}