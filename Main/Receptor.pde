class Receptor {

  // fields
  PVector pos;
  int colour=255;

  // constructor
  Receptor(float xpos, float ypos, color colour) {
    this.pos = new PVector(xpos, ypos);
    this.colour = colour;
  }

  // update receptors
  void update() {
    detectCollision();
    drawMe();
  }

  // check if the arrow has hit the receptor
  void detectCollision() {
    for (int i=0; i<arrowAL.size(); i++) {
      if (arrowAL.get(i).hitCharacter(this)) {
        arrowAL.remove(i);
      }
    }
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