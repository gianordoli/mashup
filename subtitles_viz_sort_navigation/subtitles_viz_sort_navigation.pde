/*---------- DATA ----------*/
ArrayList<Sub> subs;

/*-------- VISUALS ---------*/
//Measurement unit
int mm;

//Typography
PFont regular;
PFont italic;
int leading;

//Margins
int hMargin;
int topMargin;
int bottomMargin;

//Pagination variables
int totalHeight;
int textHeight;
int totalPages;
int pageNumber;

//PDF
import processing.pdf.*;
boolean record;

void setup() {
  //Measurement unit
  mm = 3;
  
  size(120*mm, 180*mm);  

  /*---------- DATA ----------*/    
  subs = new ArrayList<Sub>();
  String[] stringSubs1 = loadStrings("Weird.Science.1985.720p.BluRay.x264.YIFY.srt");
  String[] stringSubs2 = loadStrings("Her.2013.DVDSCR.XviD.MP3-RARBG.srt");  
  processSubs("weird_science", stringSubs1);  
  processSubs("her", stringSubs2);
  
  //Typography
  regular = createFont("Didot", 12);
  italic = createFont("Didot-Italic", 12);  
  leading = 16;  
  
  //Margins
  hMargin = 20*mm;
  topMargin = 10*mm;
  bottomMargin = 24*mm;  

  //Pagination variables
  totalHeight = (subs.size() + 2) * leading;
  textHeight = height - (topMargin + bottomMargin);
  totalPages = ceil(totalHeight / textHeight);
  pageNumber = 1;      

  //PDF
  record = false;
  
  sortBy("time");
  
  //Setting subs positions
  mapPos();
  
  println(totalPages);
}

void draw() {
  
  if(record){
      beginRecord(PDF, "allPages.pdf");
  }
  
  background(255);
  colorMode(HSB); 

  pushMatrix();
    translate(0, - textHeight * (pageNumber - 1));
      
      translate(hMargin, topMargin);

        for(int i = 0; i < subs.size(); i++){
          Sub mySub = subs.get(i);
          if(textHeight * (pageNumber - 1) < mySub.pos.y &&
             mySub.pos.y < textHeight * pageNumber){
                mySub.display();
          }
        }

  popMatrix();
  
  //PAGE NUMBER
  fill(0);
  PVector pageNumberPos = new PVector(0, height - (bottomMargin/2));
  //Even page
  if(pageNumber % 2 == 0){
    pageNumberPos.x = hMargin / 2;
  //Odd page
  }else{
    pageNumberPos.x = width - hMargin / 2;
  }

  textAlign(CENTER);
  textFont(regular);  
  text(pageNumber, pageNumberPos.x, pageNumberPos.y);  
  
  if(record){
    endRecord();
    record = false;
  }  
}

void mapPos(){
  int y = 0;
  for (int i = 0; i < subs.size(); i++){
    Sub mySub = subs.get(i);
//    PVector currPos = new PVector(0, map(i,
//                                      0, subs.size() - 1,
//                                      0, totalHeight));
    PVector currPos = new PVector(0, y);
    
    String myText = mySub.speech;
    textFont(regular);
    float myWidth = textWidth(myText);
    if(myWidth > width - (2 * hMargin)){
      y += (2 * leading);
    }else{
      y += leading;
    }
    
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
      if(pageNumber > 1){
        pageNumber --;      
      }
    }else if(keyCode == RIGHT || keyCode == DOWN){ 
      if(pageNumber < totalPages - 1){     
        pageNumber ++;
      }
    }    
  }else if(key == ' '){
//    save("her_weird_science_page_" + pageNumber + ".png");
    record = true;
  }
  println(pageNumber);
}

void sortBy(String comparator){
  //Creating an empty array that will store the values
  //we want to compare
  int[] values = new int[subs.size()];
  for(int i = 0; i < subs.size(); i++){
    //We'l compare based on...?
    if(comparator == "time"){
      values[i] = subs.get(i).time;
    }
  }
  //Sorting those values
  values = sort(values);
//  values = reverse(values);
  
  //This temporary ArrayList will store the objects sorted
  ArrayList<Sub> tempList = new ArrayList<Sub>();
  
  //Looping through each sorted value
  for(int i = 0; i < values.length; i++){
    //Looping through each object
    for(int j = 0; j < subs.size(); j++){
      //We'l compare based on...?
      int objectValue = 0;
      if(comparator == "time"){
        objectValue = subs.get(j).time;  
      }
      
      //If the sorted value is found...
      if(values[i] == objectValue){
        //Add the object to the temporary list and jump to the next iteration
        tempList.add(subs.get(j));
        subs.remove(subs.get(j));
        break;
      }
    }
  }
  //Replace the original list with the sorted one
  subs = tempList;
  println(values);
}
