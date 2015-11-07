class Arrow {

  // fields
  PVector pos;
  PVector vel;
  int colour=255;

  // constructor
  Arrow(float xpos, float ypos, float xvel, float yvel, color colour) {
    this.pos = new PVector(xpos, ypos);
    this.vel = new PVector(xvel, yvel);
    this.colour = colour;
  }

  // update arrow
  void update() {
    move();
    drawMe();
  }

  // update position with velocity
  void move() { 
    pos.add(vel);
  }

  // return true if characters touch eachother's bounding boxes 
  boolean hitCharacter(Receptor r)
  {
    boolean xCollision = abs(pos.x - r.pos.x) < 5;
    boolean yCollision = abs(pos.y - r.pos.y) < 5;
    return xCollision && yCollision;
  }

  // draw arrow
  void drawMe() {
    pushMatrix();
    translate(height/2, width/2);
    ellipseMode(CENTER); 
    fill(colour);
    ellipse(pos.x, pos.y, receptorRadius, receptorRadius);
    popMatrix();
  }
}