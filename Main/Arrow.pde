class Arrow {

  // fields
  PVector pos;
  PVector vel;
  PImage img;

  // constructor
  Arrow(float xpos, float ypos, float xvel, float yvel) {
    this.pos = new PVector(xpos, ypos);
    this.vel = new PVector(xvel, yvel);
    img = loadImage("note_red.png");
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
    imageMode(CENTER); 
    image(img, pos.x, pos.y);
    popMatrix();
  }
}