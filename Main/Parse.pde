class Parse {

  // fields
  String[] lines;
  String[][] difficulties;
  float[][] bpms;
  int[][][][][][][][] notes;
  boolean notesEnd;

  // constructor
  Parse() {
    lines  = new String[0];
    difficulties = new String[0][0];
    bpms =  new float[0][0];
    notes = new int[0][0][0][0][0][0][0][0];
  }

  // functionality
  void getNotes(int j) {
    int[] lineNotes = new int[0];

    for (int i=0; i < lines[j].length(); i++) {
      // accept normal notes and hold heads as notes
      if (lines[j].charAt(i) == 1 || lines[j].charAt(i) == 2) {
        append(lineNotes, i);
      }
    }
  }

  void run() {
    lines = loadStrings("video out e/video out e.sm");
    int i = 0;

    // Title, song artist, audio offset, BPMs
    while (lines[i].length() > 1 && lines[i].charAt(0) == '#') { 

      if (lines[i].substring(1, lines[i].indexOf(":")).equals("TITLE")) {
        String title = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("ARTIST")) {
        String artist = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("OFFSET")) {
        float offset = float(lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";")));
      }

      // Assumes bpms are in one line
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("BPMS")) {
        String bpmString = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
        String[] bpmSubstrings = bpmString.split(",");
        for (int j=0; j<bpmSubstrings.length; j++) {
          float[] split = float(bpmSubstrings[j].split("="));
          bpms = (float[][])append(bpms, new float[]{split[0], split[1]});
        }
        // Convert the array of strings to an array of floats
        for (int j=0; j<bpms.length; j++) {
          for (int k=0; k<2; k++) {
            bpms[j][k] = (float)bpms[j][k];
          }
        }


        //console.log(bpms);
      }
      i++;
    }

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

    //console.log(difficulties);
    boolean selectHardest = true;
    int selectedDifficulty = 0;

    if (selectHardest) {
      selectedDifficulty = difficulties.length - 1;
    } else {
      // user prompt to select difficulty goes here
    }

    int currentLine = int(difficulties[selectedDifficulty][1]);

    /* fixes issue where if at the start of a difficulty, the .sm file devotes a line to "  // measure 1", the program is expecting note information, and produces an error
     if (lines[currentLine].indexOf('measure') != -1) {
     currentLine ++;
     }*/

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

      int notesInMeasure = i - currentLine;

      int measureNum = 1;
      // get current bpm  
      // measureNum is initially 1  
      // assumes bpm starts at the beginning of a measure  
      // assumes bpms are in chronological order

      i = bpms.length - 1;

      while (bpms[i][0]/4 > measureNum - 1) {
        i --;
      }
      float currentBpm = bpms[i][1];

      // get seconds per notes
      float secPerNote = 240 / currentBpm / notesInMeasure;

      int linesProcessed = 0;

      float currentTime = 0;
      int[] lineNotes = new int[0];
      // put notes into array with time values
      if (currentTime == 0 && linesProcessed == 0) {
        getNotes(currentLine);

        if (lineNotes.length != 0) {
          for (i=0; i < lineNotes.length; i++) {
            append(notes[lineNotes[i]], 0);
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
            append(notes[lineNotes[i]], currentTime);
          }
        }
        linesProcessed ++;
        currentLine ++;
      }

      currentLine ++;
      measureNum ++;
    } while (notesEnd == false);
    // end stepfile conversion <p></p>   
  }
}