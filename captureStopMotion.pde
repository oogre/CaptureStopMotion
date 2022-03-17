import processing.video.*;
import controlP5.*;

ControlP5 cp5;
Capture cam;
Button captureBtn;
Button previewBtn;
Button cancelBtn;
PImage oldFrame;
ArrayList<ControlFrame> previews;

String DATA_PATH; 

void settings() {
  size(1280, 720);
}

void setup() { 

  DATA_PATH = System.getProperty("user.home") + "/Documents/catptureStopMotion/";

  File dPath = new File(DATA_PATH);
  if (!dPath.exists()) {
    dPath.mkdir();
  }

  previews = new ArrayList<ControlFrame> ();

  surface.setResizable(true);
  cp5 = new ControlP5(this);
  cp5.addScrollableList("dropdown")
    .setLabel("Select your camera")
    .setPosition(0, 0)
    .setSize(width/4-1, 200)
    .setBarHeight(25)
    .setItemHeight(25)
    .addItems(Arrays.asList(Capture.list()))
    .setType(ScrollableList.DROPDOWN);

  captureBtn = cp5.addButton("Capture")
    .setPosition(width/4+1, 0)
    .setSize(width/4-1, 25);

  cancelBtn = cp5.addButton("Cancel")
    .setPosition(2*width/4.0 + 1, 0)
    .setSize(width/4 - 1, 25);

  previewBtn = cp5.addButton("Preview")
    .setPosition(3*width/4.0 + 1, 0)
    .setSize(width/4 - 1, 25);

  loadLastFrame();
}

void draw() {
  if (null != cam) {
    captureBtn.show();
  } else {
    captureBtn.hide();
  }

  if (null!=oldFrame) {
    cancelBtn.show();
  } else {
    cancelBtn.hide();
  }

  if (countPicture() > 1) {
    previewBtn.show();
  } else {
    previewBtn.hide();
  }

  if (null == cam) {
    background(0);

    fill(255);
    textSize(25);
    textAlign(CENTER, CENTER);
    text("Pictures saved at : " + DATA_PATH, width/2, height/2);
    return;
  }

  if (cam.available() == true) {
    cam.read();
  }

  background(0);
  pushMatrix();
  translate(0, 25);

  image(cam, 0, 0, width, height - 25);
  if (oldFrame != null) {
    tint(255, 128);
    image(oldFrame, 0, 0, width, height - 25);
    tint(255);
  }
  popMatrix();
}

public void dropdown(int n) {
  ScrollableList self = cp5.get(ScrollableList.class, "dropdown");
  List<Map<String, Object>> items = self.getItems();
  Map<String, Object> curentItem = self.getItem(n);

  cam = new Capture(this, 1280, 720, (String)(curentItem.get("name")));
  cam.start();

  CColor c = new CColor();
  c.setBackground(color(255, 0, 0));

  CColor defaultC = new CColor();
  defaultC.setBackground(color(3, 46, 89));

  for (Map<String, Object> item : items) {
    item.put("color", defaultC);
  }
  curentItem.put("color", c);
}

public void Preview(int theValue) {
  previews.add(new ControlFrame(this, 1280, 720, "Preview"));
}


public void Capture(int theValue) {
  PImage frame = cam.copy();
  frame.save(getNextFrameName());
  oldFrame = frame.copy();
  for (ControlFrame preview : previews) {
    preview.addPicture(frame.copy());
  }
}

public void Cancel(int theValue) {
  deleteLastFrame();
  oldFrame = loadLastFrame();
  for (ControlFrame preview : previews) {
    preview.deleteLastFrame();
  }
}
