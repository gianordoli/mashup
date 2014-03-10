ArrayList<Sub> subs;
PFont regular;
PFont italic;
int mm;
int leading;

int pageNumber;
int totalHeight;


void setup() {
  
//  println(PFont.list());
    
  subs = new ArrayList<Sub>();

//  String[] stringSubs1 = loadStrings("Gravity.2013.1080p.WEB-DL.H264-PublicHD.srt");
  String[] stringSubs1 = loadStrings("Weird.Science.1985.720p.BluRay.x264.YIFY.srt");
  String[] stringSubs2 = loadStrings("Her.2013.DVDSCR.XviD.MP3-RARBG.srt");
//  processSubs("gravity", stringSubs1);  
  processSubs("weird_science", stringSubs1);  
  processSubs("her", stringSubs2);
  
  regular = createFont("Didot", 16);
  italic = createFont("Didot-Italic", 16);  
  mm = 6;  
  pageNumber = 1;
  leading = 24;
  totalHeight = (subs.size() + 2) * leading; 
//  size(145*mm, 210*mm);
  size(145*mm, totalHeight);

  colorMode(HSB);  
  
//  mapPos();
  sortBy("time");
  
}

void draw() {
  
  
  background(255);
  for(int i = 0; i < subs.size(); i++){
    Sub mySub = subs.get(i);
//    mySub.pos.y = i * leading;
    mySub.display();
//    if(height * (pageNumber - 1) < mySub.pos.y && mySub.pos.y < height * pageNumber){
//      pushMatrix();
//        translate(0, - height * (pageNumber - 1));
//          mySub.display();
//      popMatrix();
//    }
  }  
}
//
//void mapPos(){
//  
//  for (int i = 0; i < subs.size(); i++){
//    Sub mySub = subs.get(i);
//    PVector currPos = new PVector(0, map(mySub.time,
//                                      subs.get(0).time, subs.get(subs.size()-1).time,
//                                      0, totalHeight));
//    mySub.setPos(currPos);    
//  }
//}

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
    save("her_weird_science_page_" + pageNumber + ".png");    
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
  values = reverse(values);
  
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


