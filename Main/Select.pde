class Select extends Screen {

  // Constructor
  Select() {
  }

  void screenSetup() {
    minim.stop();
  }
  void screenDraw() {
    display();
  }
  void display() {
    background(100);
    textAlign(CENTER,CORNER);
    textFont(basic, height/5);
    text("Song Select",width/2,height/2);
  }
}