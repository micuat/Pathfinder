import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setupTouchpad() {
  oscP5 = new OscP5(this, 12345);
}

void updateTouchPad() {
}

void oscEvent(OscMessage m) {
  print("### received an osc message.");
  print(" addrpattern: "+m.addrPattern());
  println(" typetag: "+m.typetag());

  if (m.addrPattern().equals("/Object/rand")) println("-------------------------------------------------------");

  else if (m.addrPattern().equals("/Object/iterate")) {
    cp5PlaybackStyle = 1;
    choreo.changePlayback();  
    r.activate(cp5PlaybackStyle - 1);
  }
  else if (m.addrPattern().equals("/Object/loop")) {
    cp5PlaybackStyle = 2;
    choreo.changePlayback();  
    r.activate(cp5PlaybackStyle - 1);
  } 
  else if (m.addrPattern().equals("/Object/manual")) {
    cp5PlaybackStyle = 3;
    choreo.changePlayback();
    r.activate(cp5PlaybackStyle - 1);
  }
  else if (m.addrPattern().equals("/Object/faderManual")) {
    cp5SeekAniValue = m.get(0).floatValue();
  }

  else if (m.addrPattern().equals("/Object/90")) {
    if (m.get(0).floatValue() == 1)
      cp5QuantAnim = true;
    else
      cp5QuantAnim = false;
  }  
  else if (m.addrPattern().equals("/Object/3D")) {
    if (m.get(0).floatValue() == 1)
      cp53DAnim = true;
    else
      cp53DAnim = false;
  } 

  else if (m.addrPattern().equals("/Motion/speed")) {
    cp5TransSpeed = 0.1 + m.get(0).floatValue() * 3;
    cp5.getController("cp5TransSpeed").setValue(cp5TransSpeed);
  }
  else if (m.addrPattern().equals("/Motion/delay")) {
    cp5TransDelay = 0.1 + m.get(0).floatValue() * 3;
    cp5.getController("cp5TransDelay").setValue(cp5TransDelay);
  }

  else if (m.addrPattern().equals("/Motion/linear")) {
    println("--------------");
    choreo.easingType = 0;
    d1.setValue(choreo.easingType);
  }
  else if (m.addrPattern().equals("/Motion/sin")) {
    choreo.easingType = 14;
    d1.setValue(choreo.easingType);
  }
  else if (m.addrPattern().equals("/Motion/elastic")) {
    choreo.easingType = 22;
    d1.setValue(choreo.easingType);
  }  
  else if (m.addrPattern().equals("/Motion/bounce")) {
    choreo.easingType = 26;
    d1.setValue(choreo.easingType);
  }

  else if (m.addrPattern().equals("/Communication/fill")) {
    if (m.get(0).floatValue() == 1)
      cp5DisplayPolygon = true;
    else
      cp5DisplayPolygon = false;
  }
  else if (m.addrPattern().equals("/Communication/outline")) {
    if (m.get(0).floatValue() == 1) {
      cp5DisplayLines = true;
      cp5DisplayPoints = true;
    } else {
      cp5DisplayLines = false;
      cp5DisplayPoints = false;
    }
  }
  else if (m.addrPattern().equals("/Communication/trails")) {
    if (m.get(0).floatValue() == 1)
      cp5DisplayTrails = true;
    else
      cp5DisplayTrails = false;
  }
}