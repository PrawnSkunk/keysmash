class Transmitter {

  // fields
  PVector pos;
  PImage img;

  // constructor
  Transmitter(float xpos, float ypos) {
    this.pos = new PVector(xpos, ypos);
    img = loadImage("receptor.png");
  }

  // update receptors
  void update() {
    drawMe();
  }

  // draw receptors
  void drawMe() {
    pushMatrix();
    translate(height/2, width/2);
    imageMode(CENTER); 
    image(img, pos.x, pos.y);
    popMatrix();
  }
}