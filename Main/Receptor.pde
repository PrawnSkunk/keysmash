class Receptor {

  // fields
  PVector pos;
  PImage img;

  // constructor
  Receptor(float xpos, float ypos) {
    this.pos = new PVector(xpos, ypos);
    img = loadImage("receptor.png");
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
    imageMode(CENTER); 
    image(img, pos.x, pos.y);
    popMatrix();
  }
}