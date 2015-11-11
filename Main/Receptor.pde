class Receptor {

  // Fields
  PVector pos;
  PImage img;

  // Constructor
  Receptor(float xpos, float ypos) {
    this.pos = new PVector(xpos, ypos);
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
    tint(255,col);
    image(img, height/2+pos.x, width/2+pos.y);
    popMatrix();
  }
}