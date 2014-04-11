class Sub{
  String movie;
  int index;
  int time;
  String speech;
  PVector pos;
  int size;
  
  
  Sub(String _movie, int _index, int _time, String _speech){
    movie = _movie;
    index = _index;
    time = _time;
    speech = _speech;
    size = 2;
  }
  
  void setPos(PVector _pos){
    pos = _pos;
//    println(pos);
  }
  
  void display(){
    noStroke();
    if(movie == "weird_science"){
      fill(160, 200, 200);
    }else if(movie == "her"){
      fill(240, 255, 200);
    }
    
    String myText = speech;

    if(speech.indexOf("<i") != -1){
      textFont(italic);
      myText = myText.substring(myText.indexOf(">") + 1); 
      myText = myText.substring(0, myText.indexOf("<"));      
    }else{
      textFont(regular);
    }
    textAlign(LEFT);
    textLeading(leading); 
    text(myText, pos.x, pos.y, width - (2 * hMargin), 3*leading);
  }
}
