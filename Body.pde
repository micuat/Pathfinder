class Body {
  int typeId = 0;
  ArrayList<MeshElement> element = new ArrayList<MeshElement>(0);

  public Body() {
  }

  public Body(Body source) {
    element = new ArrayList<MeshElement>(0);

    for (int i = 0; i < source.element.size(); i++) {
      boolean found = false;
      for (int j = 0; j < element.size(); j++) {
        if (i != j) {
          if (m.compareMesh(source.element.get(i).mesh, element.get(j).mesh)) {
            found = true; 
            println("yes-------------------------------------");
          } else ;
        }
      }
      if (!found)
        element.add(new MeshElement(source.element.get(i).mesh));
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
    //mesh.setTrans(new Vec3D(calcRandomValue(-cp5WorldRangeX, cp5WorldRangeX), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY), calcRandomValue(-cp5WorldRangeY, cp5WorldRangeY)));
    if(bodyInfos[id] == null) {
      bodyInfos[id] = new BodyInfo();
    }
    mesh.setTrans(new Vec3D(bodyInfos[id].x, bodyInfos[id].y, 0));
    println(id + " " + bodyInfos[id].x + " " + bodyInfos[id].y);

    element = new ArrayList<MeshElement>(0);
    for (int i = 0; i < mesh.meshes.length; i++) {
      element.add(new MeshElement(mesh.meshes[i]));
    }
  }

  void reset() {
    init(typeId);
  }
}