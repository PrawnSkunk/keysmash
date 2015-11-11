class Arrow {

  // Fields
  PVector pos;
  PVector vel;
  PImage img;

  // Constructor
  Arrow(float xpos, float ypos, float xvel, float yvel) {
    this.pos = new PVector(xpos, ypos);
    this.vel = new PVector(xvel, yvel);
    img = loadImage("note_red.png");
  }

  // Update arrow
  void update() {
    move();
    drawMe();
  }

  // Update position with velocity
  void move() { 
    pos.add(vel);
  }

  // Return true if objects touch eachother's bounding boxes 
  boolean hitCharacter(Receptor r)
  {
    boolean xCollision = abs(pos.x - r.pos.x) < 5;
    boolean yCollision = abs(pos.y - r.pos.y) < 5;
    return xCollision && yCollision;
  }

  // Draw arrow
  void drawMe() {
    pushMatrix();
    tint(255);
    translate(height/2, width/2);
    image(img, pos.x, pos.y);
    popMatrix();
  }
}