// Combine Receptor and Transmitter into superclass
ArrayList<Receptor> receptorAL = new ArrayList<Receptor>();
ArrayList<Transmitter> transmitterAL = new ArrayList<Transmitter>();
ArrayList<Arrow> arrowAL = new ArrayList<Arrow>();

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
color[] colours = { #fe000d, #ff6600, #fef200, #017b3e, #00887e, #007f9f, #3b4a9f, #9d1c5f };
boolean[] pressed = new boolean[keys.length];

// Immobile object locations
float receptorRadius = 64;
float transmitterRadius = 600;

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
  arrowAL.add(new Arrow(posArr[0]*transmitterRadius, posArr[1]*transmitterRadius, -posArr[0]*speedmod, -posArr[1]*speedmod, colours[i]));
}

void setup() {
  size(800, 800);
  noStroke();

  for (int i = 0; i < pos.length; i++) {
    float[] posArr = pos[i].array();

    // Instantiate Receptors
    receptorAL.add(new Receptor(posArr[0]*receptorRadius, posArr[1]*receptorRadius, colours[i]));

    // Instantiate Transmitters
    transmitterAL.add(new Transmitter(posArr[0]*transmitterRadius, posArr[1]*transmitterRadius));
  }
}

void draw() {

  background (0);

  for (int i=0; i<pos.length; i++) {

    // Update Receptors
    receptorAL.get(i).update();

    // Update Transmitters
    transmitterAL.get(i).update();
  }

  for (int i=0; i<arrowAL.size(); i++) {

    // Update Arrows
    arrowAL.get(i).update();
  }
}