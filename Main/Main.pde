// Initialize empty array lists
ArrayList<Arrow> arrowAL = new ArrayList<Arrow>();
ArrayList<Receptor> receptorAL = new ArrayList<Receptor>();
ArrayList<Transmitter> transmitterAL = new ArrayList<Transmitter>();

// Declare script as a global variable
Parse script;

// Numeric Keypad Grid
PVector[] pos = { 
  new PVector(-1, 0), 
  new PVector(-1, -1), 
  new PVector(0, -1), 
  new PVector(1, -1), 
  new PVector(1, 0), 
  new PVector(1, 1), 
  new PVector(0, 1), 
  new PVector(-1, 1) };

// Key Setup
char[] keys = { '4', '7', '8', '9', '6', '3', '2', '1' };
boolean[] pressed = new boolean[keys.length];

// Fixed object locations
float receptorRadius = 64;

// Options
float speedmod = 8.0;

void keyPressed() {

  // Check if directional keys are pressed
  for (int i=0; i < keys.length; i++) {
    if (key == keys[i]) {
      pressed[i] = true;
      addArrow(i);
    }
  }
}

void keyReleased() {

  // Check if directional keys are released
  for (int i=0; i < keys.length; i++) {
    if (key == keys[i]) {
      pressed[i] = false;
    }
  }
}

// Instantiate Arrow at respective transmitter
void addArrow(int i) {
  float[] posArr = pos[i].array();
  arrowAL.add(new Arrow(posArr[0]*width, posArr[1]*height, -posArr[0]*speedmod, -posArr[1]*speedmod));
}

void setup() {
  size(640, 640);
  noStroke();

  // Run parser
  script = new Parse();
  script.run();

  // Instantiate objects
  for (int i = 0; i < pos.length; i++) {
    float[] posArr = pos[i].array();
    receptorAL.add(new Receptor(posArr[0]*receptorRadius, posArr[1]*receptorRadius));
    transmitterAL.add(new Transmitter(posArr[0]*width, posArr[1]*height));
  }
}

void draw() {

  background (0);

  // Update Objects
  for (int i=0; i<pos.length; i++) {
    receptorAL.get(i).update();
    transmitterAL.get(i).update();
  }

  for (int i=0; i<arrowAL.size(); i++) {

    // Update Arrows
    arrowAL.get(i).update();
  }
}