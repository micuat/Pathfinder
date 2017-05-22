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

  public void draw(color colorI, boolean debug, boolean drawGrid) {
    pushMatrix();  
    //drawMesh(meshTransform.cur, colorI, debug,drawGrid);  
    popMatrix();
  }
}