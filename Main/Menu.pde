class Menu extends Screen {

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
  }
}