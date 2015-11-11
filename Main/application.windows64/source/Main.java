import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import controlP5.*; 
import java.util.Date; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Main extends PApplet {

// Import libraries



Minim minim;
AudioPlayer song;
ControlP5 cp5;
boolean toggleValue;

// Initialize empty array lists
ArrayList<Arrow> arrowAL;
ArrayList<Receptor> receptorAL;
ArrayList<Transmitter> transmitterAL;
Parse sm;
Screen scn;

// Gameplay data
PVector[] grid; // Receptor column position
char[] keys; // Input keysetup
boolean[] pressed; // Current keys pressed
int[] rotations;
PVector[] transl;

String songname = "video out e";
float receptorRadius = 72.0f;
float speedmod = height/11;
float timeSinceLastStateSwitch;
float time;
PFont font;

final int GAME_MENU = 0;
final int GAME_PLAY = 1;
int state = GAME_MENU;

public void setup() {  
  
  
  noStroke();
  imageMode(CENTER);
  scn = new Screen();
  setupLibraries();
}

public void draw() {
  switch(state) {
  case GAME_MENU: 
    scn.gameMenuDraw(); 
    break;
  case GAME_PLAY:
    scn.gamePlayDraw();
    break;
  }
}

public void toggle_state(boolean theFlag) {
  if (theFlag==true) {
    state = GAME_MENU;
    scn.gameMenuSetup();
  } else {
    state = GAME_PLAY;
    scn.gamePlaySetup();
    timeSinceLastStateSwitch = millis();
  }
}

public void setupLibraries() {
  minim = new Minim(this);
  cp5 = new ControlP5(this);
  cp5.addToggle("toggle_state") .setPosition(50,50) .setSize(30, 30) .setValue(true) .setColorActive(color(0xffff0000)) .setColorBackground(color(0xff00ff00));
}
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
      //img = loadImage("note_blue.png");
      img = loadImage("note_red.png");
    } else { 
      img = loadImage("note_red.png");
    }
  }

  // Update arrow
  public void update() {
    move();
    drawMe();
  }

  // Update position with velocity
  public void move() { 
    pos.add(vel);
  }

  // Return true if objects touch eachother's bounding boxes 
  public boolean hitCharacter(Receptor r)
  {
    boolean xCollision = abs(pos.x - r.pos.x) <= 6;
    boolean yCollision = abs(pos.y - r.pos.y) <= 6;
    return xCollision && yCollision;
  }

  // Draw arrow
  public void drawMe() {
    pushMatrix();
    translate(width/2+pos.x, height/2+pos.y);
    rotate(radians(r*45));
    image(img, 0, 0);
    popMatrix();
  }
}
class Parse {

  // Fields;
  String[][] difficulties;
  float[][] bpms, notes;
  String[] lines, bpmSubstrings;
  float[] split;
  int[] lineNotes;
  String title, artist, bpmString;
  float offset, currentBpm, secPerNote, currentTime;
  int selectedDifficulty, currentLine, notesInMeasure, measureNum, linesProcessed, i, j;
  boolean notesEnd, selectHardest;

  // Constructor
  Parse() {
    this.difficulties = new String[0][0];
    this.bpms =  new float[0][0];
    this.notes = new float[8][0];
    this.bpmSubstrings = new String[0];
    this.lines  = new String[0];
    this.split = new float[0];
    this.lineNotes = new int[0];
    this.selectHardest = true;
    this.measureNum = 1;
  }

  // Functionality
  public void run(String path) {
    lines = loadStrings(path);
    getInfo();
    selectDifficulty();
    noteConversion();
  }

  // Append note position index to lineNotes[]
  public void getNotes(int u) {
    lineNotes = new int[0];  
    for (int i=0; i < lines[u].length(); i++) {   

      // Only accept taps and hold heads as notes
      if (lines[u].charAt(i) == '1' || lines[u].charAt(i) == '2') {
        lineNotes = (int[])append(lineNotes, i);
      }
    }
  }

  public void getBpms() {

    // Assumes #BPMS:; are one line
    if (lines[i].substring(1, lines[i].indexOf(":")).equals("BPMS")) {
      bpmString = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      bpmSubstrings = bpmString.split(",");

      for (int j=0; j<bpmSubstrings.length; j++) {
        split = PApplet.parseFloat(bpmSubstrings[j].split("="));
        bpms = (float[][])append(bpms, new float[]{split[0], split[1]});
      }
    }
  }

  // Get title, song artist, audio offset, BPMs
  public void getInfo() {
    while (lines[i].length() > 1 && lines[i].charAt(0) == '#') { 

      if (lines[i].substring(1, lines[i].indexOf(":")).equals("TITLE")) {
        title = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("ARTIST")) {
        artist = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("OFFSET")) {
        offset = PApplet.parseFloat(lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";")));
      }

      getBpms();
      i++;
    }
  }

  public void selectDifficulty() {
    // this loop extracts difficulties in the form: ["difficulty", line number where notes start]
    do {  

      while (i < lines.length) {
        if (lines[i].equals("#NOTES:")) break;
        i++;
      }

      if (i+3 < lines.length) {
        i += 3;

        // encountered bizarre error where difficulties array would simply return "C6" or "C5", fixed after PC restart
        difficulties = (String[][])append(difficulties, new String[]{lines[i].substring(5, lines[i].length()-1), str(i+3)});
      }
    } 
    while (i < lines.length);

    if (selectHardest) {
      selectedDifficulty = difficulties.length - 1;
    } else {
      // user prompt to select difficulty goes here
    }

    currentLine = PApplet.parseInt(difficulties[selectedDifficulty][1]);

    //fixes issue where if at the start of a difficulty, the .sm file devotes a line to "  // measure 1", the program is expecting note information, and produces an error
    if (lines[currentLine].indexOf("measure") != -1) {
      currentLine ++;
    }
  }

  public void noteConversion() {
    // begin note conversion loop
    do {
      // count number of notes in a measure
      i = currentLine;

      // assumes #NOTES ends with a semicolon
      while ((lines[i].substring(0, 1).equals(",") == false) && (lines[i].substring(0, 1).equals(";") == false)) {
        i ++;
      }

      // check if the notes have finished, if true, this is last loop

      if (lines[i].equals(";")) {
        notesEnd = true;
      } else {
        notesEnd = false;
      }

      notesInMeasure = i - currentLine;

      // get current bpm  
      // measureNum is initially 1  
      // assumes bpm starts at the beginning of a measure  
      // assumes bpms are in chronological order

      i = bpms.length - 1;

      while (bpms[i][0]/4 > measureNum - 1) {
        i --;
      }
      currentBpm = bpms[i][1];

      // get seconds per notes
      secPerNote = 240 / currentBpm / notesInMeasure;

      linesProcessed = 0;

      // put notes into array with time values
      if (currentTime == 0 && linesProcessed == 0) {
        getNotes(currentLine);
        if (lineNotes.length != 0) { 
          for (i=0; i < lineNotes.length; i++) {
            notes[lineNotes[i]] = (float[])append(notes[lineNotes[i]], 0);
          }
        }

        linesProcessed = 1;
        currentLine ++;
      } 

      while (linesProcessed < notesInMeasure) {
        currentTime += secPerNote;
        getNotes(currentLine);

        if (lineNotes.length != 0) {
          for (i=0; i < lineNotes.length; i++) {
            notes[lineNotes[i]] = (float[])append(notes[lineNotes[i]], currentTime);
          }
        }
        linesProcessed ++;
        currentLine ++;
      }
      currentLine ++;
      measureNum ++;
    } while (notesEnd == false);
  }
}
class Receptor {

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
  public void update() {
    detectCollision();
    drawMe();
  }

  // Check if the arrow has hit the receptor
  public void detectCollision() {
    for (int i=0; i<arrowAL.size(); i++) {
      if (arrowAL.get(i).hitCharacter(this)) {
        arrowAL.remove(i);
      }
    }
  }

  // Draw receptors
  public void drawMe() {
    pushMatrix();
    translate(width/2+pos.x, height/2+pos.y);
    rotate(radians(r*45));
    image(img, 0, 0);
    popMatrix();
  }
}
class Screen {

  // Constructor
  Screen() {
  }

  // Functionality
  public void display() {
    fill(0);
    rect(0, 0, width, height);
  }
  public void HUD() {
    float maxWidth = width-height;
    fill(25);
    rect(0, 0, maxWidth/2, height);
    rect(width-maxWidth/2, 0, maxWidth/2, height);
  }

  public void gameMenuSetup() {
    surface.setResizable(true);
    minim.stop();
    song.close();
  }

  public void gameMenuDraw() {
    
    font = loadFont("Amelia-Basic-48.vlw");
    fill(25); 
    rect(0, 0, width, height*0.15f); // Section 1

    fill(50); 
    rect(0, height*0.15f, width, height*0.25f); // Section 2

    strokeWeight(height/250);
    stroke(255);
    ellipseMode(CENTER);
    ellipse(width/2, height*0.15f, height/9, height/9); // Avatar
    noStroke();

    fill(75); 
    rect(0, height*0.4f, width, height*0.6f); // Section 3

    fill(255); 
    textAlign(LEFT, CENTER);
    textFont(font, height/25);
    text(songname, height*0.15f/4, height*0.15f/3);

    textAlign(CENTER, BOTTOM);
    textFont(font, height/12);
    text("1,000,000", width/2, height*0.32f);
    textFont(font, height/25);
    text("score", width/2, height*0.3f+height/15);
    textFont(font, height/18);
    text("100.00%", width/4, height*0.32f);
    textFont(font, height/25);
    text("accuracy", width/4, height*0.3f+height/15);
    textFont(font, height/18);
    text("1,000x", width-width/4, height*0.32f);
    textFont(font, height/25);
    text("combo", width-width/4, height*0.3f+height/15);
    
    font = loadFont("Amelia-Basic-Bold-255.vlw");
    textFont(font, height/1.8f);
    text("S", width/2, height);
    
  }

  public void gamePlaySetup() {
    surface.setResizable(true);
    arrowAL = new ArrayList<Arrow>();
    receptorAL = new ArrayList<Receptor>();
    transmitterAL = new ArrayList<Transmitter>();
    grid = new PVector[]{ new PVector(-1, 0), new PVector(0, 1), new PVector(0, -1), new PVector(1, 0), new PVector(-1, -1), new PVector(-1, 1), new PVector(1, -1), new PVector(1, 1) };
    keys = new char[]{ '4', '2', '8', '6', '7', '1', '9', '3' };
    rotations = new int[]{2, 0, 4, 6, 3, 1, 5, 7};
    //rotations = new int[]{6,4,0,2,7,5,1,3};
    pressed = new boolean[keys.length];
    sm = new Parse();
    parse();
    gridSetup();
    loadAudio();
  }

  public void gamePlayDraw() {
    time = getTime();
    scn.display();
    spawnNotes();
    drawObjects();
    HUD();
  }

  public void drawObjects() {

    // Update Receptors
    for (int i=0; i<grid.length; i++) {
      receptorAL.get(i).update();
    }
    // Update Arrows
    for (int i=0; i<arrowAL.size(); i++) {
      arrowAL.get(i).update();
    }
  }

  // Load and play audio
  public void loadAudio() {
    song = minim.loadFile(songname+"/"+songname+".mp3");
    song.rewind();
    song.play();
  }

  // Parse note data
  public void parse() {
    sm.run(songname+"/"+songname+".sm");
  }

  // Instantiate stationary objects
  public void gridSetup() {
    for (int i = 0; i < grid.length; i++) {
      float[] gridArr = grid[i].array();
      receptorAL.add(new Receptor(gridArr[0]*receptorRadius, gridArr[1]*receptorRadius, rotations[i]));
      transmitterAL.add(new Transmitter(gridArr[0]*receptorRadius*8, gridArr[1]*receptorRadius*8));
    }
  }

  // Current time
  public float getTime() {
    float currTime = (float)millis()-timeSinceLastStateSwitch;
    return (float)((currTime/1000)+sm.offset+(speedmod/30));
  }

  // Execute note data
  public void spawnNotes() {
    for (int i=0; i<grid.length; i++) {
      for (int j=0; j<sm.notes[i].length; j++) {
        if (sm.notes[i][j] - time < 0.00833f && sm.notes[i][j] - time > -0.00833f) {
          // spawn note at respective transmitter
          float[] gridArr = grid[i].array();
          arrowAL.add(new Arrow(gridArr[0]*receptorRadius*8, gridArr[1]*receptorRadius*8, -gridArr[0]*speedmod, -gridArr[1]*speedmod, rotations[i]));
          sm.notes[i][j] = 0;
        }
      }
    }
  }

  public void keyPressed() {
    for (int i=0; i < keys.length; i++) {
      if (key == keys[i]) {
        pressed[i] = true;
      }
    }
  }

  public void keyReleased() {
    for (int i=0; i < keys.length; i++) {
      if (key == keys[i]) {
        pressed[i] = false;
      }
    }
  }
}
class Transmitter {

  // Fields
  PVector pos;

  // Constructor
  Transmitter(float xpos, float ypos) {
    this.pos = new PVector(xpos, ypos);
  }
}
  public void settings() {  size(800, 600);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
