
class Body {

  MeshElement[] element=new MeshElement[0];



  public Body() {
  }

  public Body copy(Body source) {
    return new Body(this);
  }

  public Body(Body source) {
   element=new MeshElement[0];
   
  // source.element = 
    for (int i=0;i<source.element.length;i++) {      
      boolean found=false;
      for (int j=0;j<element.length;j++) {
        if (i!=j) {
          if (m.compareMesh(source.element[i].mesh, element[j].mesh)) { found = true; println("yes-------------------------------------");  }
          else ;//println("nooo-----------------------------"); 
        }
      }
       if (!found) element = (MeshElement[])  append(element, new MeshElement(source.element[i].mesh));
    }
  }

  // The OBJ Body Transformer
  public Body(OBJModel model) {
    element = new MeshElement[0];

    for (int j = 0; j < model.getSegmentCount(); j++)
    {

      Segment segment = model.getSegment(j);

      saito.objloader.Face[] faces = segment.getFaces();

      for (int i = 0; i < faces.length; i++) {
        WETriangleMesh mesh = new WETriangleMesh();
        saito.objloader.Face f = faces[i];

        PVector[] vs = f.getVertices();
        PVector[] ns = f.getNormals();

        if (f.getVertices().length>2) {
          Vec3D a = new Vec3D(vs[0].x, vs[0].y, vs[0].z);

          Vec3D b = new Vec3D(vs[1].x, vs[1].y, vs[1].z);          
          Vec3D c = new Vec3D(vs[2].x, vs[2].y, vs[2].z);
          Vec3D d = new Vec3D(0, 0, 0);

          //eraseStroke
          if (a.distanceTo(c)==0) continue;


          mesh.addFace(a, b, c);

          if (f.getVertices().length>3) 
            d = new Vec3D(vs[3].x, vs[3].y, vs[3].z);
          else 
            d = new Vec3D((c.x+a.x)/2, (c.y+a.y)/2, (c.z+a.z)/2);
          mesh.addFace(c, d, a);

          duplicateCheck(mesh);
          element = (MeshElement[])  append(element, new MeshElement(mesh));
        }
      }
    }

    println(element.length);
  }



  public Body(PFace face) {
   element =  new MeshElement[0];
    addFace(face);
  }
  
  
  public Body(PFace[] faces) {    
   element = new MeshElement[0];
    for (int i=0;i < faces.length;i++) {   
       addFace(faces[i]);
    }
  }
  

  public Body(PTri tri) {
    element = new MeshElement[0];
    addFace(tri);
  }

  public void addFace(PFace face) {
    WETriangleMesh meshI= new WETriangleMesh();
    Vec3D a = new Vec3D(face.vert[0].x, face.vert[0].y, face.vert[0].z);
    Vec3D b = new Vec3D(face.vert[1].x, face.vert[1].y, face.vert[1].z);          
    Vec3D c = new Vec3D(face.vert[2].x, face.vert[2].y, face.vert[2].z);
    Vec3D d = new Vec3D(face.vert[3].x, face.vert[3].y, face.vert[3].z);

    meshI.addFace(a, b, c);
    meshI.addFace(c, d, a);
    element = (MeshElement[])  append(element, new MeshElement(meshI));
  }


  public void  addFace(PTri tri) {
    WETriangleMesh meshI= new WETriangleMesh();
    Vec3D a = new Vec3D(tri.vert[0].x, tri.vert[0].y, tri.vert[0].z);
    Vec3D b = new Vec3D(tri.vert[1].x, tri.vert[1].y, tri.vert[1].z);          
    Vec3D c = new Vec3D(tri.vert[2].x, tri.vert[2].y, tri.vert[2].z);
    Vec3D d = new Vec3D(tri.vert[3].x, tri.vert[3].y, tri.vert[3].z);

    meshI.addFace(a, b, c);
    meshI.addFace(c, d, a);
    element = (MeshElement[])  append(element, new MeshElement(meshI));
  }

  public boolean duplicateCheck(WETriangleMesh mesh) {
    float[] a = mesh.getUniqueVerticesAsArray();
    Vec3D [] posOld = new Vec3D[4];
    
    if (a.length/3==3) {
      for (int i=0;i<3;i++) {
        posOld[i] = new Vec3D(a[i*3], a[i*3+1], a[i*3+2]);
      }
      posOld[3] = new Vec3D((posOld[0].x+posOld[2].x)/2, (posOld[0].y+posOld[2].y)/2, (posOld[0].z+posOld[2].z)/2);
      mesh.clear();
      mesh.addFace(posOld[0], posOld[1], posOld[2]);
      mesh.addFace(posOld[2], posOld[3], posOld[0]);
    }
    return true;
  }


  // The HEMESH Body Transformer
  public Body(HE_Mesh   meshI) {
    element = new MeshElement[0];

    int count=0;
    Iterator<HE_Face> iter = meshI.fItr();
    for (int i = 0; iter.hasNext(); i++) {
      HE_Face f = iter.next();
      count++;
      if (count%1==0) {
        final List<WB_IndexedTriangle2D> tris = f.triangulate();
        final List<HE_Vertex> vertices = f.getFaceVertices();
        WB_Point3d v0, v1, v2;
        WB_IndexedTriangle2D tri;
        WETriangleMesh mesh = new WETriangleMesh();
        for (int ind = 0; ind < tris.size(); ind++) {
          tri = tris.get(ind);

          v0 = vertices.get(tri.i1);
          v1 = vertices.get(tri.i2);
          v2 = vertices.get(tri.i3);

          Vec3D a = new Vec3D((float)v0.x, (float)v0.y, (float)v0.z);
          Vec3D b = new Vec3D((float)v1.x, (float)v1.y, (float)v1.z);
          Vec3D c = new Vec3D((float)v2.x, (float)v2.y, (float)v2.z);
          Vec3D d = new Vec3D((float)(c.x+a.x)/2, (float)(c.y+a.y)/2, (float)(c.z+a.z)/2);

          mesh.addFace(a, b, c);

          mesh.addFace(c, d, a);
          element = (MeshElement[])  append(element, new MeshElement(mesh));
        }
      }
    }
  }


  public void draw(color colorI, boolean debug, boolean drawGrid) {




    for (int i=0;i<element.length;i++) {



      element[i].draw(colorI, debug,drawGrid);
    }
  }
}

