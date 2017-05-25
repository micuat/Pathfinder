class Body {
  int typeId = 0;
  MeshElement[] element = new MeshElement[0];

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

  public Body(int _typeId) {
    typeId = _typeId;
    init(typeId);
  }

  void init(int id) {
    PMesh mesh;
    switch(id) {
    case 0:
      mesh = new PPoint();
      break;
    case 1:
      mesh = new PLine();
      break;
    case 2:
      mesh = new PPlate();
      break;
    case 3:
      mesh = new PTri();
      break;
    case 4:
      if (!cp53DAnim)
        mesh = new PPlate();
      else
        mesh = new PBox();
      break;
    default:
      mesh = new PPoint();
    }
    element = new MeshElement[0];
    for (int i = 0; i < mesh.meshes.length; i++) {
      element = (MeshElement[])append(element, new MeshElement(mesh.meshes[i]));
    }
  }

  void reset() {
    init(typeId);
  }
}