class Transmitter {

  // fields
  PVector pos;
  int colour;

  // constructor
  Transmitter(float xpos, float ypos) {
    this.pos = new PVector(xpos, ypos);
  }

  // update receptors
  void update() {
    drawMe();
  }

  // draw receptors
  void drawMe() {
    pushMatrix();
    translate(height/2, width/2);
    ellipseMode(CENTER); 
    fill(colour);
    ellipse(pos.x, pos.y, receptorRadius, receptorRadius);
    popMatrix();
  }
}