class Arrow {

  // Fields
  PVector pos;
  PVector vel;
  float r;
  PImage img;

  // Constructor
  Arrow(float xpos, float ypos, float xvel, float yvel, float r) {
    this.pos = new PVector(xpos, ypos);
    this.vel = new PVector(xvel, yvel); 
    this.r = r;
    if (xvel != 0 && yvel != 0) { 
      img = loadImage("/assets/note_blue.png");
      //img = loadImage("note_red.png");
    } else { 
      img = loadImage("/assets/note_red.png");
    }
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
    boolean xCollision = abs(pos.x - r.pos.x) <= 6;
    boolean yCollision = abs(pos.y - r.pos.y) <= 6;
    return xCollision && yCollision;
  }

  // Draw arrow
  void drawMe() {
    pushMatrix();
    translate(width/2+pos.x, height/2+pos.y);
    rotate(radians(r*45));
    image(img, 0, 0);
    popMatrix();
  }
}