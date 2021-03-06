class Receptor { //<>//

  // Fields
  PVector pos;
  PImage img,hit;
  float r;
  float explosionTimer;

  // Constructor
  Receptor(float xpos, float ypos, float r) {
    this.pos = new PVector(xpos, ypos);
    this.r = r;
    this.explosionTimer = 0;
    img = loadImage("/assets/note_receptor.png");
    hit = loadImage("/assets/note_hit.png");
  }

  // Update receptors
  void update() {
    detectCollision();
    drawMe();
    explosion();
  }

  // Check if the arrow has hit the receptor
  void detectCollision() {

  }
  
  void explosion(){
    if (explosionTimer>0){
      drawExplosion();
    }
    explosionTimer--;
  }

  // Draw receptors
  void drawMe() {
    pushMatrix();
    translate(width/2+pos.x, height/2+pos.y);
    rotate(radians(r*45));
    image(img, 0, 0);
    popMatrix();
  }
  
  void drawExplosion() {
    pushMatrix();
    translate(width/2+pos.x, height/2+pos.y);
    rotate(radians(r*45));
    pushStyle();
    tint(255, explosionTimer*50);
    image(hit, 0, 0);
    popStyle();
    popMatrix();
  }

}