import processing.awt.PSurfaceAWT;
import peasy.*;
import java.util.*;
import toxi.geom.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh.*;
import toxi.processing.*;

PeasyCam cam;
BodyTransform transform;
Choreo choreo;

boolean runMultiScreen = false;
PGraphics contentGr;
PGraphics contentGr2D;

void setup() {
  setupTouchpad();

  //PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  //PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  //smoothCanvas.getFrame().setAlwaysOnTop(true);
  //smoothCanvas.getFrame().removeNotify();
  //smoothCanvas.getFrame().setUndecorated(true);
  //smoothCanvas.getFrame().setLocation(0, 0);
  //smoothCanvas.getFrame().addNotify();
  size(1920, 1080, P3D);
  smooth();

  cam = new PeasyCam(this, 330);

  frameRate(29);                                      // set unlimited frame rate

  contentGr = createGraphics(width, height, P3D);
  contentGr2D = createGraphics(width, height);

  contentGr2D.beginDraw();
  contentGr2D.background(0);
  contentGr2D.endDraw();

  setupVisuals();
  setupGui();  
  setupBodyPrimitives();

  choreo = new Choreo(this);
  //start with choreo from body 0 to body 1
  transform = new BodyTransform(body[listofBody[0]], body[listofBody[1]]);

  item = new Item();
}

void draw() {
  surface.setLocation(0, 0);

  updateFrame();

  drawFrame(contentGr);

  if (runMultiScreen) {
    contentGr.loadPixels(); 
    arrayCopy(contentGr.pixels, contentGr2D.pixels); 
    contentGr2D.updatePixels();
  }

  cam.beginHUD();
  image(contentGr, 0, 0);
  drawMenu();

  surface.setTitle("Morpher || " + int(frameRate) + " fps");

  cam.endHUD();
}

void updateFrame() {
  choreo.update();
  updateVisuals();
}

void drawMenu() {
  if (isGuiDraw) drawHUD();
}

void drawFrame(PGraphics in) {
  in.beginDraw();
  //in.ortho();
  in.setMatrix(getMatrix()); // replace the PGraphics-matrix
  in.colorMode(RGB);
  in.background(backgroundCol);
  in.colorMode(HSB, 360);
  in.scale(cp5WorldScale);
  if(false) {
    Vec3D p = new Vec3D(0, 0, 0);
    for(int i = 0; i < transform.transformBody.element.size(); i++) {
      Vec3D pMin = transform.transformBody.element.get(i).mesh.getBoundingBox().getMin();
      Vec3D pMax = transform.transformBody.element.get(i).mesh.getBoundingBox().getMax();
      //Vec3D p = pMin.interpolateTo(pMax, 0.5f);
      p.addSelf(pMin);
      p.addSelf(pMax);
    }
    p.scaleSelf(1.0f / (transform.transformBody.element.size() * 2.0f));
    in.translate(-p.x, -p.y, -p.z);
  }
  in.translate(0, 0, -5);

  drawVisuals(in);
  in.endDraw();
}