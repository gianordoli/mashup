import processing.pdf.*;

ArrayList<Sub> subs;
PFont regular;
PFont italic;
int mm;
int leading;

int pageNumber;
int totalHeight;

int leftMargin;
int rightMargin;
int topMargin;
int bottomMargin;

boolean record;


void setup() {
  
//  println(PFont.list());
    
  subs = new ArrayList<Sub>();

//  String[] stringSubs1 = loadStrings("Gravity.2013.1080p.WEB-DL.H264-PublicHD.srt");
  String[] stringSubs1 = loadStrings("Weird.Science.1985.720p.BluRay.x264.YIFY.srt");
  String[] stringSubs2 = loadStrings("Her.2013.DVDSCR.XviD.MP3-RARBG.srt");
//  processSubs("gravity", stringSubs1);  
  processSubs("weird_science", stringSubs1);  
  processSubs("her", stringSubs2);
  
  regular = createFont("Didot", 12);
  italic = createFont("Didot-Italic", 12);  
  mm = 3;  
  pageNumber = 1;
  leading = 24;
  record = false;
  totalHeight = (subs.size() + 2) * leading; 
  size(120*mm, 180*mm);   
  
  leftMargin = 20*mm;
  rightMargin = 10*mm;
  topMargin = 20*mm;
  bottomMargin = 20*mm;  
  
  mapPos();
  
}

void draw() {
  
  if(record){
      beginRecord(PDF, "page_" + pageNumber + ".pdf");
  }
  
  background(255);
  colorMode(HSB); 

  int textHeight = height - (topMargin + bottomMargin);

  pushMatrix();
    translate(0, - textHeight * (pageNumber - 1));
      translate(leftMargin, topMargin);

      for(int i = 0; i < subs.size(); i++){
        Sub mySub = subs.get(i);
        if(textHeight * (pageNumber - 1) < mySub.pos.y &&
           mySub.pos.y < textHeight * pageNumber){
              mySub.display();
        }
      }

  popMatrix();
  
  if(record){
    endRecord();
    record = false;
  }
  
}

void mapPos(){
  
  for (int i = 0; i < subs.size(); i++){
    Sub mySub = subs.get(i);
    PVector currPos = new PVector(0, map(mySub.time,
                                      subs.get(0).time, subs.get(subs.size()-1).time,
                                      0, totalHeight));
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

void keyPressed(){
  if(key == CODED){    
    if(keyCode == LEFT || keyCode == UP){
      if(pageNumber > 0){
        pageNumber --;      
      }
    }else if(keyCode == RIGHT || keyCode == DOWN){      
      pageNumber ++;
    }    
  }else if(key == ' '){
//    save("her_weird_science_page_" + pageNumber + ".png");
    record = true;
  }
  println(pageNumber);
}

