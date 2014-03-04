import processing.pdf.*;

ArrayList<Sub> subs;
PFont regular;
PFont italic;
int mm;
int leading;

void setup() {
  
  colorMode(HSB);
  println(PFont.list());
    
  subs = new ArrayList<Sub>();

//  String[] stringSubs1 = loadStrings("Gravity.2013.1080p.WEB-DL.H264-PublicHD.srt");
  String[] stringSubs1 = loadStrings("Weird.Science.1985.720p.BluRay.x264.YIFY.srt");
  String[] stringSubs2 = loadStrings("Her.2013.DVDSCR.XviD.MP3-RARBG.srt");
//  processSubs("gravity", stringSubs1);  
  processSubs("weird_science", stringSubs1);  
  processSubs("her", stringSubs2);
  
  regular = createFont("Didot", 8);
  italic = createFont("Didot-Italic", 8);  
  mm = 3;  
  leading = 12;
  int newHeight = (subs.size() + 2) * leading; 
  size(210*mm, newHeight);
  beginRecord(PDF, "her_weird_science_2.pdf");  
  
  mapPos();
  
}

void draw() {  
  
  background(255);
    
  for (int i = 0; i < subs.size(); i++){
    Sub mySub = subs.get(i);
//    println(mySub.pos.x);
//    println(mySub.index);
    mySub.display();
  }
  noLoop();
  endRecord();
}

void mapPos(){
  
  for (int i = 0; i < subs.size(); i++){
    Sub mySub = subs.get(i);
    PVector currPos = new PVector(0, map(mySub.time,
                                      subs.get(0).time, subs.get(subs.size()-1).time,
                                      0, height));
    mySub.setPos(currPos);    
  }
}

void debug(){
  for (int i = 0; i < subs.size(); i++) {
    println("-----------------");    
    println(subs.get(i).index);
    println(subs.get(i).time);
    println(subs.get(i).speech);    
  }
}

void processSubs(String _movie, String[] mySubs) {

  int i = 0;

  while (i < mySubs.length - 3) {
    //   while (i < 20) { 

    int index = parseInt(mySubs[i]);
    i++;

    //2 - Subtitle time    
//    String time = mySubs[i];
    int time = toSeconds(mySubs[i]);
    i++;

    String speech = mySubs[i];
    i++;
    
    //If the next line is also text
    while (mySubs[i].length() != 0 && parseInt(mySubs[i]) == 0) {  //Second line?
      speech += " " + mySubs[i];
      i++;
    }
    
    //If the next line is a paragraph
    //"while", because there may be more than one paragraph     
    while(mySubs[i].length() == 0){
      i++;
    }    

    subs.add(new Sub(_movie, index, time, speech));
  }
}

int toSeconds(String myTime) {
  myTime = myTime.substring(0, 8);
  int hours = parseInt(myTime.substring(0, 2));
  int minutes = parseInt(myTime.substring(3, 5));
  int seconds = parseInt(myTime.substring(6, 8));
//  myTime = "h: " + hours + ", min: " + minutes + ", s: " + seconds;
  seconds += (60 * minutes) + (3600 * hours);
//  println(myTime);
  return seconds;
}

