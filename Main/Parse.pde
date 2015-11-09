class Parse {

  // fields
  String[] lines;
  String[][] difficulties;
  float[][] bpms;
  float[][][][][][][][] notes;
  float[] r0 = new float[0];
  float[] r1 = new float[0];
  float[] r2 = new float[0];
  float[] r3 = new float[0];
  float[] r4 = new float[0];
  float[] r5 = new float[0];
  float[] r6 = new float[0];
  float[] r7 = new float[0];
  boolean notesEnd;
  String title;
  String artist;
  float offset;
  String bpmString;
  String[] bpmSubstrings;
  float[] split;
  boolean selectHardest = true;
  int selectedDifficulty;
  int currentLine;
  int notesInMeasure;
  int measureNum = 1;
  float currentBpm;
  float secPerNote;
  int linesProcessed;
  float currentTime;
  int[] lineNotes = new int[0];
  int j=0;

  // constructor
  Parse() {
    lines  = new String[0];
    difficulties = new String[0][0];
    bpms =  new float[0][0];
    notes = new float[0][0][0][0][0][0][0][0];
  }

  // functionality
  void getNotes(int u) {
    lineNotes = new int[0];  
    for (int i=0; i < lines[u].length(); i++) {   
      // accept normal notes and hold heads as notes
      if (lines[u].charAt(i) == '1' || lines[u].charAt(i) == '2') {
        lineNotes = (int[])append(lineNotes, i);
      }
    }
  }

  void run() {
    lines = loadStrings("video out e/video out e.sm");
    int i = 0;

    // Title, song artist, audio offset, BPMs
    while (lines[i].length() > 1 && lines[i].charAt(0) == '#') { 

      if (lines[i].substring(1, lines[i].indexOf(":")).equals("TITLE")) {
        title = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("ARTIST")) {
        artist = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
      }
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("OFFSET")) {
        offset = float(lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";")));
      }

      // Assumes bpms are in one line
      if (lines[i].substring(1, lines[i].indexOf(":")).equals("BPMS")) {
        bpmString = lines[i].substring(lines[i].indexOf(":")+1, lines[i].indexOf(";"));
        bpmSubstrings = bpmString.split(",");
        for (int j=0; j<bpmSubstrings.length; j++) {
          split = float(bpmSubstrings[j].split("="));
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
            if (lineNotes[i] == 0) r0 = append(r0, 0);
            else if (lineNotes[i] == 1) r1 = append(r1, 0);
            else if (lineNotes[i] == 2) r2 = append(r2, 0);
            else if (lineNotes[i] == 3) r3 = append(r3, 0);
            else if (lineNotes[i] == 4) r4 = append(r4, 0);
            else if (lineNotes[i] == 5) r5 = append(r5, 0);
            else if (lineNotes[i] == 6) r6 = append(r6, 0);
            else if (lineNotes[i] == 7) r7 = append(r7, 0);
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
            //notes[lineNotes[i]] = (float[][][][][][][])append(notes[lineNotes[i]], currentTime);
            if (lineNotes[i] == 0) r0 = append(r0, currentTime);
            else if (lineNotes[i] == 1) r1 = append(r1, currentTime);
            else if (lineNotes[i] == 2) r2 = append(r2, currentTime);
            else if (lineNotes[i] == 3) r3 = append(r3, currentTime);
            else if (lineNotes[i] == 4) r4 = append(r4, currentTime);
            else if (lineNotes[i] == 5) r5 = append(r5, currentTime);
            else if (lineNotes[i] == 6) r6 = append(r6, currentTime);
            else if (lineNotes[i] == 7) r7 = append(r7, currentTime);
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