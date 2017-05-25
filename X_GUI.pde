import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

import controlP5.*;

int mode = 3;

boolean isGuiInit = false;
boolean isGuiDraw = true;

boolean drawPointVsLines = false;
float aniRot = 0;
float aniRotNo = 0;
float aniTransX = 0;
float aniTransY = 0;
float aniTransZ = 0;
float aniSizeX = 0;
float aniSizeY = 0;

int framePos = 0;

//Playback 0 = auto ; 1 = Loop ; 2 = Manual;
int cp5PlaybackStyle = 0;
float cp5SeekAniValue = 0;

boolean cp53DAnim = false;
boolean cp5QuantAnim = true;
boolean cp5Shuffle = false;

float cp5TransSpeed = 1.4;
float cp5TransDelay = 0.0;
float cp5TransSwing = 0.1;
float cp5TransMass = 0.1;

boolean cp5DisplayPoints = true;
boolean cp5DisplayLines = true;
boolean cp5DisplayPolygon = false;
boolean cp5DisplayNormals = false;
boolean cp5DisplayTrails = false;

boolean cp5DisplayLast = true;
boolean cp5DisplaySource = true;
boolean cp5DisplayDestiny = true;

float globalRotate = 0;

int     cp5WorldScale = 21;
float   cp5WorldSpeed = 0.6;
int     cp5WorldRangeY = 12;
int     cp5WorldRangeX = 24;
boolean cp5WorldOrigin = false;
boolean cp5WorldGrid = true;
boolean cp5WorldRoom = true;

boolean cp5UseCamera = false;

ControlP5 cp5;
int unitSpace = 25;

DropdownList[] objectGui;
DropdownList d1;
RadioButton r;

void setupGui() {
  cp5 = new ControlP5(this);
  cp5.setColorBackground(color(40));
  cp5.setColorForeground(color(130));
  cp5.setColorActive(color(155)); 

  cp5.setAutoDraw(false);

  ControlGroup cg = cp5.addGroup("Animation", width - 275, (int)(unitSpace * 1.5));
  cp5.begin(cg, 0, unitSpace);
  cp5.addToggle("cp53DAnim").setLabel("3D");
  cp5.addToggle("cp5QuantAnim").setLabel("Quant");
  cp5.addToggle("cp5Shuffle").setLabel("Shuffle Choreo");

  r = cp5.addRadioButton("radioButton")
    .setPosition(unitSpace, unitSpace)
    .setSize(25, 15)
    .setItemsPerRow(3)
    .setSpacingColumn(125)
    .addItem("Auto", 1)
    .addItem("Loop", 2)
    .addItem("Manual", 3)
    .setColorActive(highlight1)
    ;
  r.activate(0);

  cp5.addSlider("cp5TransSpeed", 0.1, 8).linebreak().setLabel("Speed").setPosition(0, unitSpace * 3);
  cp5.addSlider("cp5TransDelay", 0, 5).linebreak().setLabel("Delay").setPosition(0, unitSpace * 4);
  cp5.addSlider("cp5TransSwing", 0.01, 0.999).linebreak().setLabel("Swing").setPosition(0, unitSpace * 5);
  cp5.addSlider("cp5TransMass", 0.01, 1).linebreak().setLabel("Mass").setPosition(0, unitSpace * 6);

  d1 = cp5.addDropdownList("Easing").setPosition(150, unitSpace * 4 - 10);
  customize(d1); // customize the first list
  d1.setGroup(cg);
  cp5.end();

  ControlGroup cd = cp5.addGroup("Display", width - 275, unitSpace * 10);
  cp5.begin(cd, 0, unitSpace);
  cp5.addToggle("cp5DisplayPolygon").setLabel("Polygon");
  cp5.addToggle("cp5DisplayPoints").setLabel("Points");
  cp5.addToggle("cp5DisplayLines").setLabel("Lines");
  cp5.addToggle("cp5DisplayNormals").setLabel("Normals");  
  cp5.addToggle("cp5DisplayTrails").setLabel("Trails").linebreak();
  cp5.addToggle("cp5DisplayLast").setLabel("Show Last").linebreak();
  cp5.addToggle("cp5DisplaySource").setLabel("Show Source").linebreak();
  cp5.addToggle("cp5DisplayDestiny").setLabel("Show Destiny");
  cp5.end();

  ControlGroup cw = cp5.addGroup("World", width - 275, unitSpace * 20);
  cp5.begin(cw, 0, unitSpace);
  cp5.addSlider("cp5WorldRangeX", 1, 50).linebreak().setLabel("RangeX").linebreak();
  cp5.addSlider("cp5WorldRangeY", 1, 50).linebreak().setLabel("RangeY").linebreak();
  cp5.addSlider("cp5WorldSpeed", 0, 2).linebreak().setLabel("Rotate Speed").linebreak();
  cp5.addSlider("cp5WorldScale", 1, 50).linebreak().setLabel("Scale").linebreak();
  cp5.addToggle("cp5WorldOrigin").setLabel("Origin");
  cp5.addToggle("cp5WorldGrid").setLabel("Grid");
  cp5.addToggle("cp5WorldRoom").setLabel("Room");
  cp5.addButton("cp5Save").setLabel("Save").setPosition(0, unitSpace*20).setId(101);
  cp5.addButton("cp5Load").setLabel("Load").setPosition(100, unitSpace*20).setId(100);
  cp5.end();

  setupObjectGui();
}


void setupObjectGui() {
  objectGui = new DropdownList[listofBody.length];
  for (int i = 0; i < objectGui.length; i++)
    customizeObjects(i);

  isGuiInit = true;
}

void drawGui() {
  pushStyle();
  noStroke();
  fill(160, 40);
  rect(width - 300, 0, 300, height);
  cp5.draw(); 

  if (mouseX > width - 300) {
    cam.setActive(false);  //PeasyCam off
  } else
    cam.setActive(true);
  popStyle();

  updateObjectGUI();
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.getCaptionLabel().set("easing");
  ddl.getCaptionLabel().getStyle().marginTop = 3;
  ddl.getCaptionLabel().getStyle().marginLeft = 3;
  ddl.getValueLabel().getStyle().marginTop = 3;
  for (int i = 0; i < easingsVariableNames.length; i++) {
    ddl.addItem(easingsVariableNames[i], i);
  }
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void customizeObjects( int num) {  
  int num2 = num + 1;
  objectGui[num] = cp5.addDropdownList("object_" + num2).setPosition(unitSpace + ((num) * 150), unitSpace * 3);
  // a convenience function to customize a DropdownList
  objectGui[num].setBackgroundColor(color(190));
  objectGui[num].setItemHeight(20);
  objectGui[num].setBarHeight(15);
  objectGui[num].setSize(100, 500);
  objectGui[num].getCaptionLabel().getStyle().marginTop = 3;
  objectGui[num].getCaptionLabel().getStyle().marginLeft = 3;
  objectGui[num].getValueLabel().getStyle().marginTop = 3;
  for (int i=0; i<nameofBody.length; i++) {
    objectGui[num].addItem(nameofBody[i], i);
  }
  //ddl.scroll(0);
  objectGui[num].setColorBackground(color(60));
  objectGui[num].setColorActive(color(255, 128));
}

void updateObjectGUI() {
  for (int i = 0; i < objectGui.length; i++) {

    if (objectGui[i] != null) {
      String y = int(i + 1) + "";
      objectGui[i].getCaptionLabel().set(y + "_" + nameofBody[listofBody[i]]);
      if (i == indexCurTarget)
        objectGui[i].setColorBackground(highlight1);
      else
        objectGui[i].setColorBackground(color(60));

      if (i == (indexCurTarget - 1) % objectGui.length) objectGui[i].setColorBackground(color(155));
    }
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(r)) {
    cp5PlaybackStyle = int(theEvent.getGroup().getValue());
    choreo.changePlayback();

    return;
  }

  if (theEvent.getId() == 100) selectInput("load settings", "fileLoadCP5");
  if (theEvent.getId() == 101) selectInput("save settings", "fileSaveCP5");

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : " + theEvent.getGroup().getValue() + " from " + theEvent.getGroup());

    String name = "" + theEvent.getGroup();

    println(name);
    if ("Easing [DropdownList]".equals(name)) {
      choreo.easingType = (int)theEvent.getGroup().getValue();
      println("yeeeeeeeeeeees");
    }

    for(int i = 0; i < 8; i++) {
      if (name.equals("object_" + str(i+1) + " [DropdownList]"))
        listofBody[i] = (int)theEvent.getGroup().getValue();
    }
    println(listofBody);
  }
}

void keyReleased() {

  if (key == CODED) {
    if (keyCode == LEFT) {
      if (framePos == 0)
        framePos = 1920;
      else
        framePos = 0;
    } else if (keyCode == RIGHT) {
      if (framePos == 0)
        framePos = 1920;
      else
        framePos = 0;
    }
  } 

  switch(key) {
  case 'n' : 
    choreo.jumpNextTarget();
    break;

  case 'g' :
    isGuiDraw = !isGuiDraw;
    break; 

  case 'r' : 
    enterRecording = !enterRecording; 
    item.clear();
    break;

  case 'c' : 
    globalRotate = 0;
    break;

  case 'd' : 
    drawDebug = !drawDebug;
    break;

  case 'w' :
    item.writeToFile();  
    break;

  case 's' : 
    choreo.setupAni();  
    break;

  case 'l' : 
    drawPointVsLines = !drawPointVsLines;
    break;
  }
}

void fileLoadCP5(File selection)
{ 
  String initStringLoadCP5 = selection.getAbsolutePath();
  println(initStringLoadCP5);
  cp5.loadProperties(initStringLoadCP5);
}

void fileSaveCP5(File selection)
{ 
  String initStringLoadCP5 = selection.getAbsolutePath();
  cp5.saveProperties(initStringLoadCP5);
}