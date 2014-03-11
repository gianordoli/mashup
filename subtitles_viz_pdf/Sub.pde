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
//      pos.x = width*1/6;
    }else if(movie == "her"){
      fill(255, 255, 200);
//      pos.x = width*3/6;
    }
//    pos.x = width*1/3;
//    ellipse(pos.x, pos.y, size, size);
//      pos.x = leftMargin;
      if(speech.indexOf("<i>") != -1){
        textFont(italic);
      }else{
        textFont(regular);
      }
      text(speech, pos.x, pos.y);
  }
}
