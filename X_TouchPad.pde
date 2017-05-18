/**
 * oscP5sendreceive by andreas schlegel
 * example shows how to send and receive osc messages.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setupTouchpad() {
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12345);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  // myRemoteLocation = new NetAddress("192.168.178.198",12346);
}


void updateTouchPad() {
}

void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());


  if (theOscMessage.addrPattern().equals("/Object/rand")) println("-------------------------------------------------------");
  if (theOscMessage.addrPattern().equals("/Object/pointpoint")) pointPoint();
  if (theOscMessage.addrPattern().equals("/Object/lineline")) lineLine();
  if (theOscMessage.addrPattern().equals("/Object/planeplane")) planePlane();

  if (theOscMessage.addrPattern().equals("/Object/pointline")) pointLine();
  if (theOscMessage.addrPattern().equals("/Object/pointplane")) pointPlane();  
  if (theOscMessage.addrPattern().equals("/Object/lineplane")) linePlane(); 

  if (theOscMessage.addrPattern().equals("/Object/rand")) randObj();
  if (theOscMessage.addrPattern().equals("/Object/planeBox")) {
    planeBox();
    cp53DAnim=true;
  }


  if (theOscMessage.addrPattern().equals("/Object/iterate")) {
    cp5PlaybackStyle=1;
    choreo.changePlayback();  
    r.activate(cp5PlaybackStyle-1);
  }
  if (theOscMessage.addrPattern().equals("/Object/loop")) {
    cp5PlaybackStyle=2;
    choreo.changePlayback();  
    r.activate(cp5PlaybackStyle-1);
  } 
  if (theOscMessage.addrPattern().equals("/Object/manual")) {
    cp5PlaybackStyle=3; 
    choreo.changePlayback();  
    r.activate(cp5PlaybackStyle-1);
  }
  if (theOscMessage.addrPattern().equals("/Object/faderManual")) {
    cp5SeekAniValue=theOscMessage.get(0).floatValue();
  }
  
  
  

  if (theOscMessage.addrPattern().equals("/Object/90")) {
    if (theOscMessage.get(0).floatValue()==1) 
    cp5QuantAnim=true;
    else cp5QuantAnim=false;
  }  
   if (theOscMessage.addrPattern().equals("/Object/3D")) {
    if (theOscMessage.get(0).floatValue()==1) 
    cp53DAnim=true;
    else cp53DAnim=false;
  } 
  
  
  

  if (theOscMessage.addrPattern().equals("/Motion/speed")) {
    cp5TransSpeed = 0.1 + theOscMessage.get(0).floatValue() * 3;  
    cp5.controller("cp5TransSpeed").setValue(cp5TransSpeed);
  }
  if (theOscMessage.addrPattern().equals("/Motion/delay")) {
    cp5TransDelay = 0.1 + theOscMessage.get(0).floatValue() * 3;  
    cp5.controller("cp5TransDelay").setValue(cp5TransDelay);
  }


  if (theOscMessage.addrPattern().equals("/Motion/linear")) {
    println("--------------");
    choreo.easingType = 0; 
    d1.setValue(choreo.easingType);
  }
  if (theOscMessage.addrPattern().equals("/Motion/sin")) {
    choreo.easingType = 14; 
    d1.setValue(choreo.easingType);
  }
  if (theOscMessage.addrPattern().equals("/Motion/elastic")) {
    choreo.easingType =  22;
    d1.setValue(choreo.easingType);
  }  
  if (theOscMessage.addrPattern().equals("/Motion/bounce")) {
    choreo.easingType = 26; 
    d1.setValue(choreo.easingType);
  }


  if (theOscMessage.addrPattern().equals("/Communication/fill")) {
    if (theOscMessage.get(0).floatValue()==1) 
      cp5DisplayPolygon=true;
    else cp5DisplayPolygon=false;
  }

  if (theOscMessage.addrPattern().equals("/Communication/outline")) {
    if (theOscMessage.get(0).floatValue()==1) {
      cp5DisplayLines=true;
      cp5DisplayPoints=true;
    }
    else {
      cp5DisplayLines=false;
      cp5DisplayPoints=false;
    }
  }


  if (theOscMessage.addrPattern().equals("/Communication/trails")) {
    if (theOscMessage.get(0).floatValue()==1) 
      cp5DisplayTrails=true;
    else cp5DisplayTrails=false;
  }
  /*
boolean cp5DisplayPoints=true;
   boolean cp5DisplayLines=true;
   boolean cp5DisplayPolygon=true;
   boolean cp5DisplayNormals=true;
   boolean cp5DisplayTrails=true;*/
}


/*
### received an osc message. addrpattern: /Object/rand typetag: f
 ### received an osc message. addrpattern: /Object/rand typetag: f
 ### received an osc message. addrpattern: /Object/pointpoint typetag: f
 ### received an osc message. addrpattern: /Object/lineline typetag: f
 ### received an osc message. addrpattern: /Object/lineline typetag: f
 ### received an osc message. addrpattern: /Object/planeplane typetag: f
 ### received an osc message. addrpattern: /Object/pointline typetag: f
 ### received an osc message. addrpattern: /Object/pointline typetag: f
 ### received an osc message. addrpattern: /Object/pointplane typetag: f
 ### received an osc message. addrpattern: /Object/pointplane typetag: f
 ### received an osc message. addrpattern: /Object/lineplane typetag: f
 ### received an osc message. addrpattern: /Object/iterate typetag: f
 ### received an osc message. addrpattern: /Object/iterate typetag: f
 ### received an osc message. addrpattern: /Object/loop typetag: f
 ### received an osc message. addrpattern: /Object/loop typetag: f
 ### received an osc message. addrpattern: /Object/manual typetag: f
 ### received an osc message. addrpattern: /Object/manual typetag: f
 
 
 
 
 */
