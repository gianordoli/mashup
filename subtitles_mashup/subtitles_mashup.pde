ArrayList<Sub> subs1;

void setup() {

  subs1 = new ArrayList<Sub>();

  String[] stringSubs1 = loadStrings("Gravity.2013.1080p.WEB-DL.H264-PublicHD.srt");
  String[] stringSubs2 = loadStrings("Her.2013.DVDSCR.XviD.MP3-RARBG.srt");
  processSubs(stringSubs2);
  
  for (int i = 0; i < subs1.size(); i++) {
    println("-----------------");    
    println(subs1.get(i).index);
    println(subs1.get(i).time);
    println(subs1.get(i).speech);    
  }  
}

void draw() {
}

void processSubs(String[] mySubs) {
  
  int i = 0;
  
  while (i < mySubs.length - 2) {
//   while (i < 20) { 
    
    int index = parseInt(mySubs[i]);
    i++;

    //2 - Subtitle time    
    String time = mySubs[i];
    i++;
    
    String speech = mySubs[i];
    i++;
    while(mySubs[i].length() != 0){  //Second line?
      speech += mySubs[i];
      i++;        
    }
    i++;  //jump to next line

    subs1.add(new Sub(index, time, speech));    
  }
}

