class Body {

  MeshElement[] element=new MeshElement[0];

  public Body() {
  }

  public Body(Body source) {
    element = new MeshElement[0];

    for (int i = 0; i < source.element.length; i++) {
      boolean found = false;
      for (int j = 0; j < element.length; j++) {
        if (i != j) {
          if (m.compareMesh(source.element[i].mesh, element[j].mesh)) { 
            found = true; 
            println("yes-------------------------------------");
          } else ;
        }
      }
      if (!found)
        element = (MeshElement[])append(element, new MeshElement(source.element[i].mesh));
    }
  }

  public Body(PMesh mesh) {
    element = new MeshElement[0];
    for (int i = 0; i < mesh.faces.length; i++) {
      addFace(mesh.faces[i]);
    }
  }

  public void addFace(PFace face) {
    WETriangleMesh meshI = new WETriangleMesh();
    PVector[] v = face.vert;
    Vec3D a = new Vec3D(v[0].x, v[0].y, v[0].z);
    Vec3D b = new Vec3D(v[1].x, v[1].y, v[1].z);
    Vec3D c = new Vec3D(v[2].x, v[2].y, v[2].z);
    Vec3D d = new Vec3D(v[3].x, v[3].y, v[3].z);

    meshI.addFace(a, b, c);
    meshI.addFace(c, d, a);
    element = (MeshElement[])append(element, new MeshElement(meshI));
  }
}