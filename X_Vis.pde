//Global Visualization Variables//////////////
/////////////////////////////////////////////

color backgroundCol = color(30, 100, 48);
color highlight1 = color(360);
color highlight2 = color(360);

color[] vertColor = new color[4];


float strokeWeightTrails = 2;
float strokeWeightObjects =1.0f/4.0f;
float strokeWeightPoints = strokeWeightObjects;
float strokeWeightRecording = strokeWeightObjects;

Trails trails;
VisEdges visEdges;

void setupVisuals() {
  Ani.init(this);

  visEdges = new VisEdges();

  colorMode(HSB, 360);

  trails = new Trails();
  updateVisualStyle();
}

public void updateVisualStyle() {
  backgroundCol = color(250, 110, 0);
  strokeWeightTrails = 0.4f;
  strokeWeightObjects = 1.0f/8.0f;
  strokeWeightPoints = strokeWeightTrails;
  strokeWeightRecording = strokeWeightTrails;
  highlight1 = color(204, 300, 270, 360);
  highlight2 = color(190, 249, 243, 360);
} 

public void updateVisuals() {
  visEdges.update();
  trails.update(transform.transformBody);

  if (enterRecording)
    enterBodyRecording(transform.transformBody, true);
}

public void drawVisuals(PGraphics in) {
  strokeWeightObjects = 1.0f / 8.0f;
  strokeWeightTrails = 0.4f;
  drawWorld(in);   
  drawBodies(in);
  visEdges.draw(in);
  if (enterRecording)
    item.show(in);
}

public void drawBodies(PGraphics in) {
  if (cp5DisplayDestiny)
    drawBody(in, transform.targetBody, color(360, 0), highlight1);
  if (cp5DisplaySource)
    drawBody(in, transform.sourceBody, color(360, 0), highlight1);

  drawBody(in, transform.transformBody, color(360, 100), color(360));
}