
class ControlFrame extends PApplet {
  int w, h;
  PImage current;
  int cursor = 0;
  PApplet parent;
  ArrayList<PImage> pictures;
  int FPS = 10;
  int delayMillis;
  long t0; 
  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    delayMillis = 1000/FPS;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(10, 10);
    pictures = new ArrayList<PImage>();
    ArrayList<File> pictFile = getPicturesAt();
    for (File f : pictFile) {
      pictures.add(loadImage(f.getAbsolutePath()));
    }
    surface.setResizable(true);
  }

  void addPicture(PImage frame) {
    pictures.add(frame);
  }

  void deleteLastFrame() {
    pictures.remove(pictures.size()-1);
  }

  void draw() {
    if (pictures.size()<= 0) {
      background(0);
      return;
    }

    image(pictures.get(cursor%pictures.size()), 0, 0, width, height);

    long t1 = millis();
    if (t1 - t0 > delayMillis) {
      cursor++;
      if (cursor >= pictures.size()) {
        cursor = 0;
      }
      t0 = t1;
    }
  }
}
