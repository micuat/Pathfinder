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
    for (int i = 0; i < mesh.meshes.length; i++) {
      element = (MeshElement[])append(element, new MeshElement(mesh.meshes[i]));
    }
  }
}