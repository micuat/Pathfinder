class MeshElement {
  //current mesh in transform process
  WETriangleMesh mesh = new WETriangleMesh();
  MeshTransform meshTransform;

  boolean chosen = false;
  Vec3D center = new Vec3D(0, 0, 0);

  public MeshElement() {
    meshTransform = new MeshTransform(mesh, mesh);
    setCenter();
  }

  public MeshElement copy() {
    return new MeshElement(this);
  }

  //Copy Constructor - to spawn new Meshes if target Mesh has more then Origin
  public MeshElement(MeshElement I) {
    mesh = new WETriangleMesh();
    this.mesh = I.mesh.copy();
    setCenter();
  }

  public MeshElement(WETriangleMesh meshI) {
    mesh = meshI.copy();        
    meshTransform = new MeshTransform(mesh, mesh);
    setCenter();
  }

  public void setCenter() {
    center = m.getCenter(mesh);
  }

  public void setTargetElement(MeshElement targetElement) {
    mesh = m.update(mesh);
    targetElement.mesh = m.update(targetElement.mesh);

    meshTransform = new MeshTransform(mesh, targetElement.mesh);
  }

  public void update(float rotAmount, float rotNormAmount, float transAmountX, float transAmountY, float transAmountZ, float sizeAmountX, float sizeAmountY, float triAmount) {
    meshTransform.update(rotAmount, rotNormAmount, transAmountX, transAmountY, transAmountZ, sizeAmountX, sizeAmountY, triAmount);
    mesh = meshTransform.cur.copy();
  }

  class MeshTransform {

    WETriangleMesh cur;
    WETriangleMesh src;
    WETriangleMesh dst;

    TransformInfo info;

    boolean motionClap = true;
    int motionClapIndex = -1;
    Vec3D motionClapOffset = new Vec3D(0, 0, 0);

    public MeshTransform(WETriangleMesh srcI, WETriangleMesh dstI) {
      cur = srcI.copy();
      src = srcI.copy();
      dst = dstI.copy();

      if (motionClap) checkMotionClap();

      checkMotionClapOffset();

      info = new TransformInfo(src, dst);
      info.calcMesh(motionClapOffset);
    }

    public void checkMotionClap() {
      Vec3D[] verts = m.getVertexVec(cur);
      if (verts.length > 2 && motionClap) {
        motionClapIndex = (int)random(0, verts.length - 1);
        motionClapIndex = 1;
      } else {
        motionClap = false;
        motionClapIndex = -1;
      }
    }

    public void checkMotionClapOffset() {
      motionClapOffset = new Vec3D(0, 0, 0);
      WETriangleMesh srcL = src.copy();

      srcL = updateTransAndRot(srcL, src, dst, 1, 1, 0, 0, 0);
      Vec3D a = m.getCenter(srcL);
      Vec3D b = m.getCenter(src);

      motionClapOffset = a.sub(b);
    }

    public MeshTransform copy() {
      return new MeshTransform(this);
    }

    public MeshTransform(MeshTransform I) {
      this.cur = I.cur.copy();
      this.src = I.src.copy();
      this.dst = I.dst.copy();
    }

    public void update(float rotAmount, float rotNormAmount, float transAmountX, float transAmountY, float transAmountZ, float sizeAmountX, float sizeAmountY, float triAmount) {
      if (checkForEnd(rotAmount, rotNormAmount, transAmountX, transAmountY, transAmountZ, sizeAmountX, sizeAmountY, triAmount)) {
      } else {
        cur = updateTransAndRot(cur, src, dst, rotAmount, rotNormAmount, transAmountX, transAmountY, transAmountZ);
        cur = m.update(cur);
        cur = updateScale(cur, sizeAmountX, sizeAmountY, triAmount);
        cur = m.update(cur);
      }
    }

    public WETriangleMesh updateTransAndRot(WETriangleMesh cur, WETriangleMesh src, WETriangleMesh dst, float rotAmount, float rotNormAmount, float amountX, float amountY, float amountZ) {

      src = m.update(src);
      dst = m.update(dst);
      cur = src.copy();

      cur = m.getRot(cur, dst, rotAmount, motionClapIndex);
      cur = m.update(cur);
      cur = m.getRotNormal(cur, dst, rotNormAmount);
      cur = m.update(cur);

      cur = m.getTrans(cur, dst, amountX, amountY, amountZ);

      return cur;
    }

    WETriangleMesh sample = create(new Vec3D(-0.5, 0.5, 0), new Vec3D(-0.5, -0.5, 0), new Vec3D(0.5, -0.5, 0), new Vec3D(0.5, 0.5, 0));

    public WETriangleMesh updateScale(WETriangleMesh cur, float amountX, float amountY, float triAmount) {
      WETriangleMesh curL = cur.copy();
      curL = updateTransAndRot(curL, curL, sample, 1, 1, 1, 1, 1);

      WETriangleMesh dstL = dst.copy();
      dstL = updateTransAndRot(dstL, dstL, sample, 1, 1, 1, 1, 1);

      float heightSrc = m.getHeight(src);
      float heightDst = m.getHeight(dst);
      float heightCur = m.getHeight(curL);

      float widthSrc = m.getWidth(src);
      float widthDst = m.getWidth(dst);
      float widthCur = m.getWidth(curL);

      float targetWidth = widthSrc + (widthDst - widthSrc) * amountX;
      float targetHeight = heightSrc + (heightDst - heightSrc) * amountY;
      float ax = targetWidth / widthCur;
      float ay = targetHeight / heightCur;
      curL.scale(new Vec3D(ax, ay, 0));

      ax = targetWidth / widthDst;
      ay = targetHeight / heightDst;
      dstL.scale(new Vec3D(ax, ay, 0));

      Vec3D[] verts = m.getVertexVec(curL);
      Vec3D[] vertsT = m.getVertexVec(dstL);

      verts[3] = new Vec3D(verts[3].x + (vertsT[3].x - verts[3].x) * triAmount, verts[3].y + (vertsT[3].y - verts[3].y) * triAmount, verts[3].z + (vertsT[3].z - verts[3].z) * triAmount);

      curL.clear();
      curL.addFace(verts[0], verts[1], verts[2]);
      curL.addFace(verts[2], verts[3], verts[0]);
      curL = updateTransAndRot(curL, curL, cur, 1, 1, 1, 1, 1);

      return curL;
    }

    //Due to rounding errors it does make sense to copy target Mesh, since it re-initializes the current mesh
    private boolean checkForEnd(float rotAmount, float rotNormAmount, float transAmountX, float transAmountY, float transAmountZ, float sizeAmountX, float sizeAmountY, float triAmount) {
      if (rotAmount == 0 && rotNormAmount == 0 && transAmountX == 0 && transAmountY == 0 && transAmountZ == 0 && sizeAmountX == 0 && sizeAmountY == 0 && triAmount == 0) { 
        cur = src.copy();
        return true;
      }
      if (rotAmount == 1 && rotNormAmount == 1 && transAmountX == 1 && transAmountY == 1 && transAmountZ == 1 && sizeAmountX == 1 && sizeAmountY == 1 && triAmount == 1) {
        cur = dst.copy();
        return true;
      }
      return false;
    }
  }
}