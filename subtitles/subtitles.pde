import processing.pdf.*;

ArrayList<Sub> subs1;
PFont myFont;
int mm;

int leading;

void setup() {
    
  subs1 = new ArrayList<Sub>();

  String[] stringSubs1 = loadStrings("Gravity.2013.1080p.WEB-DL.H264-PublicHD.srt");
  String[] stringSubs2 = loadStrings("Her.2013.DVDSCR.XviD.MP3-RARBG.srt");
  processSubs(stringSubs2);
  
  myFont = createFont("Didot", 8);   
  mm = 3;
  leading = 10;
  int newHeight = (subs1.size() + 2) * leading; 
  size(210*mm, newHeight);
  beginRecord(PDF, "her_subs_.pdf");  
  
//  debug();
}

void draw() {  
  
  background(255);
  fill(0);
  textFont(myFont);
  
  int x = leading;
  int y = leading;
  
  for (int i = 0; i < subs1.size(); i++){
    
    Sub mySub = subs1.get(i);
    text(mySub.speech, x, y);
    y += leading;
    
//    if(y > height){
//      x = 0;
//      y = leading;
//    }
  }

  endRecord();
  noLoop();
}

void debug(){
  for (int i = 0; i < subs1.size(); i++) {
    println("-----------------");    
    println(subs1.get(i).index);
    println(subs1.get(i).time);
    println(subs1.get(i).speech);    
  }
}

void processSubs(String[] mySubs) {

  int i = 0;

  while (i < mySubs.length - 2) {
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

    subs1.add(new Sub(index, time, speech));
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

