class Receptor { //<>//

  // Fields
  PVector pos;
  PImage img;
  float r;

  // Constructor
  Receptor(float xpos, float ypos, float r) {
    this.pos = new PVector(xpos, ypos);
    this.r = r;
    img = loadImage("receptor.png");
  }

  // Update receptors
  void update() {
    detectCollision();
    drawMe();
  }

  // Check if the arrow has hit the receptor
  void detectCollision() {
    for (int i=0; i<arrowAL.size(); i++) {
      if (arrowAL.get(i).hitCharacter(this)) {
        arrowAL.remove(i);
      }
    }
  }

  // Draw receptors
  void drawMe() {
    pushMatrix();
    translate(width/2+pos.x, height/2+pos.y);
    rotate(radians(r*45));
    image(img, 0, 0);
    popMatrix();
  }
}