class Parse {

  // Fields;
  String[][] difficulties;
  float[][] bpms, notes;
  String[] lines, bpmSubstrings;
  float[] split;
  int[] lineNotes;
  String title, artist, music, bpmString, credit, subtitle;
  float duration, offset, currentBpm, secPerNote, currentTime, sampleStart, sampleLength;
  int maxCombo, selectedDifficulty, currentLine, notesInMeasure, measureNum, linesProcessed, i, j;
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
  void run(String path) {
    lines = new String[0];
    lines = loadStrings(path);
    getInfo();
    selectDifficulty();
    noteConversion();
    noteCount();
  }
  void header(String path) {
    lines = loadStrings(path);
    getInfo();
    selectDifficulty();
  }

  void noteCount() {
    for (int j=0; j<notes.length; j++) {
      if (notes[j].length > 0) maxCombo++;
    }
  }

  // Append note position index to lineNotes[]
  void getNotes(int u) {
    lineNotes = new int[0];  
    for (int i=0; i < lines[u].length(); i++) {   

      // Only accept taps and hold heads as notes
      if (lines[u].charAt(i) == '1' || lines[u].charAt(i) == '2') {
        lineNotes = (int[])append(lineNotes, i);
      }
    }
  }

  void getBpms() {

    // Assumes #BPMS:; are one line
    if (lines[i].substring(1, lines[i].indexOf(":")).equals("BPMS")) {
      bpmString = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      bpmSubstrings = bpmString.split(",");

      for (int j=0; j<bpmSubstrings.length; j++) {
        split = float(bpmSubstrings[j].split("="));
        bpms = (float[][])append(bpms, new float[]{split[0], split[1]});
      }
    }
  }

  // Get title, song artist, audio offset, BPMs
  void getInfo() {
    while (lines[i].length() > 1 && lines[i].charAt(0) == '#') { 
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("TITLE")) {
        title = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("SUBTITLE")) {
        subtitle = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("MUSIC")) {
        music = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("ARTIST")) {
        artist = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("CREDIT")) {
        credit = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("OFFSET")) {
        offset = float(lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";")));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("BACKGROUND")) {
        String bgString = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
        if (bgString.length() > 1) { 
          //background = loadImage("/songs/"+title+"/"+bgString);
        } else { 
          if (background == null) background = loadImage("/assets/gradient-01.jpg");
        }
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("SAMPLESTART")) {
        sampleStart = float(lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";")));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("SAMPLELENGTH")) {
        sampleLength = float(lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";")));
      }

      getBpms();
      i++;
    }
  }

  void selectDifficulty() {
    // this loop extracts difficulties in the form: ["difficulty", line number where notes start]
    do {  

      while (i < lines.length) {
        if (lines[i].equals("#NOTES:")) break;
        i++;
      }

      if (i+4 < lines.length) {
        i += 4;

        // encountered bizarre error where difficulties array would simply return "C6" or "C5", fixed after PC restart
        difficulties = (String[][])append(difficulties, new String[]{lines[i].substring(5, lines[i].length()-1), str(i+4)});
      }
    } 
    while (i < lines.length);

    if (selectHardest) {
      selectedDifficulty = difficulties.length - 1;
    } else {
      // user prompt to select difficulty goes here
    }

    currentLine = int(difficulties[selectedDifficulty][1]);

    //fixes issue where if at the start of a difficulty, the .sm file devotes a line to "  // measure 1", the program is expecting note information, and produces an error
    if (lines[currentLine].indexOf("measure") != -1) {
      currentLine ++;
    }
  }

  void noteConversion() {
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
            notes = (float[][])append(notes, new float[]{0, lineNotes[i]});
          }
        }

        linesProcessed = 1;
        currentLine ++;
      } 

      while (linesProcessed < notesInMeasure) {
        currentTime += secPerNote; // changes from secPerNote
        getNotes(currentLine);

        if (lineNotes.length != 0) {
          for (i=0; i < lineNotes.length; i++) {
            //println(linesProcessed+":"+currentTime+":"+lineNotes[i]);
            if (currentTime > 0) {
              notes = (float[][])append(notes, new float[]{currentTime, lineNotes[i]});
            }
          }
        }
        linesProcessed ++;
        currentLine ++;
      }
      currentLine ++;
      measureNum ++;
    } 
    while (notesEnd == false);
  }
}