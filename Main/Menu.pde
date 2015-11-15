class Menu extends Screen {

  // Constructor
  Menu() {
  }

  void screenSetup() {
    minim.stop();
  }
  void screenDraw() {
    display();
  }
  void display(){
    background(50);
    textAlign(CENTER,CORNER);
    textFont(basic, height/5);
    text("Num Lock",width/2,height/2);
  }
}