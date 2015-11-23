class Visualization {

  AudioMetaData meta;
  BeatDetect beat;
  float rad, radMax;
  int r, opacityOct, opacityLine, opacityPoint, opacityPoint2, stroke;

  Visualization() {
    this.radMax = this.rad = 70;
    this. r = 200;
    this.opacityOct = 80;
    this.opacityLine = 8;
    this.opacityPoint = 8;
    this.opacityPoint2 = 0;
    this.stroke = 4;
  }

  void drawTransitions() {
    if (transitionTimerIn>0) {
      fill(0, transitionTimerIn*(255/transitionTimerInMax));
      noStroke();
      //rect(0, 0, width, height);
      transitionTimerIn--;
    }
    if (transitionTimerOut>0) {
      fill(0, 255-transitionTimerOut*(255/transitionTimerOutMax));
      noStroke();
      //rect(0, 0, width, height);
      transitionTimerOut--; 
    }
  }

  void setupVizualization() {
    beat = new BeatDetect();
  }

  void drawVisualization(int translation){
    pushMatrix();
    translate(translation,0);
    drawVisualization();
    popMatrix();
  }
  
  void drawVisualization() {

    // detect beats
    beat.detect(song.mix); 
    if (beat.isOnset()) {
      rad = rad*0.9;
    } else {
      rad = radMax;
    }

    pushMatrix();
    translate(width/2, height/2);

    // Draw otagon
    pushMatrix();
    polygon(0, 0, rad*2, 8);  
    popMatrix();

    // Draw lines
    stroke(-1, opacityLine);
    int bsize = song.bufferSize();
    for (int i = 0; i < bsize - 1; i+=5)
    {
      float x = (r)*cos(i*2*PI/bsize);
      float y = (r)*sin(i*2*PI/bsize);
      float x2 = (r + song.left.get(i)*100)*cos(i*2*PI/bsize);
      float y2 = (r + song.left.get(i)*100)*sin(i*2*PI/bsize);
      strokeWeight(stroke);
      line(x, y, x2, y2);
    }
    beginShape();
    noFill();
    stroke(-1, opacityPoint);
    for (int i = 0; i < bsize; i+=30)
    {
      float x2 = (r + song.left.get(i)*100)*cos(i*2*PI/bsize);
      float y2 = (r + song.left.get(i)*100)*sin(i*2*PI/bsize);
      vertex(x2, y2);
      pushStyle();
      stroke(-1, opacityPoint2);
      strokeWeight(stroke);
      point(x2, y2);
      popStyle();
    }
    endShape();
    popMatrix();
    noStroke();
  }
  void polygon(float x, float y, float radius, int npoints) {
    noStroke();
    fill(-1, opacityOct);
    rotate(frameCount / -100.0);
    float angle = TWO_PI / npoints;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}