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
      fill(255, 255, 60);
    }else if(movie == "her"){
      fill(255, 255, 200);
    }
    
    String myText = speech;

    if(speech.indexOf("<i>") != -1){
      textFont(italic);
      myText = myText.substring(myText.indexOf(">") + 1); 
      myText = myText.substring(0, myText.indexOf("<"));      
    }else{
      textFont(regular);
    }

    text(myText, pos.x, pos.y, width - (leftMargin + rightMargin), 3*leading);
  }
}
