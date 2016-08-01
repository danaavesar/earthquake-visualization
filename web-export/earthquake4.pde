Table table;
Earthquake[] earthquakeArray; //an array of type Earthquake
int rowNum;
int margin = 50;
int margin_top = 100;
int radius;
PShape arrow;
float arrowX;
float arrowY;
float mousePX;
float mousePY;
float mouseXInside;
float mouseYInside;
float angle;
//boolean mouseOver = false;
int rotateVal = 0; 
PVector scaleCenter;
float zoom = 1;
float incr = 0;
PFont font;
float wordWidth;
int amountOver = 0;
String caption ="";

void setup() {
  size(900, 900);
  smooth();
  arrow = loadShape("arrow.svg");
  colorMode(HSB, 360, 100, 100, 100);
  font = loadFont("BebasNeue-48.vlw");
  table = loadTable("all_month.csv", "header");
  radius = (width-margin)/2 - 100;
  //initate earthquake array
  rowNum = table.getRowCount();
  earthquakeArray = new Earthquake[rowNum]; 
  //initiate all the Earthquake instances 
  for (int i=0; i<rowNum; i++) {
    earthquakeArray[i] = new Earthquake(table.getFloat(i, 1), table.getFloat(i, 2), table.getString(i, 0), table.getFloat(i, 4), table.getString(i, 13), 10) ;
  }
  float maxMag= max(float(table.getStringColumn(4)));
  float minMag= min(float(table.getStringColumn(4)));
  scaleCenter = new PVector(width/2, height/2);
  
}

void draw() {
  //println(frameRate); 
  //background(177, 39, 86);
  caption = "";
  background(173, 72, 74);
  translate(scaleCenter.x, scaleCenter.y);
  fill(0, 0, 100);
  textFont(font);
  textSize(18);
  textAlign(CENTER);
  text("Drag right or left to see world-wide earthquakes up to 30 days ago", 0, -radius-80);
  textSize(15);
  text("UP Key = zoom in, DOWN Key = zoom out", 0,-radius-60);
  mousePX = (mouseX-width/2);
  mousePY = (mouseY-height/2);
  mouseXInside = map(mouseX, margin, width -margin, -radius+80, radius-80);
  mouseYInside = map(mouseY, margin, height-margin, -radius+80, radius-80);
  //rotateVal++;
  pushMatrix(); 
  noStroke();
  angle = rotateVal;
  rotate(radians(angle)); 
  //draw the numbers
  for (int i=1; i<31; i++) {
    //stroke(177, 39, 100, 38);
   // stroke(map(i,1,30,230,340),80,100);
    //stroke(map(i,1,30,30,140),80,100); //rainbow color lines
    stroke(173,map(i,1,30,0,50),100,80);
    fill(173,map(i,1,30,0,50),100,80); //map(i,1,30,30,100)
    strokeWeight(2);
    rotate(radians(12));
    textSize(10);
    if (i < 10){
      text(i + " day ago", 0, -radius+2);
    }
    if (i >= 10){
      text(i + " days ago", 0, -radius+2);
    }
    if (i%7==0) {
      //stroke(120, 39, 100, 38);
      line(0, -radius+ 45, 0, -radius+10);
    } else {
      line(0, -radius + 35, 0, -radius +10);
    }
  }
  //draw arrow
  noFill();
  stroke(177, 39, 100);
  strokeWeight(3);

  popMatrix(); 
      if(angle<0){
      angle = (-angle);
    }
    if(angle>360){
      angle = angle%360;
    } 
  //println(angle);
  
  for (Earthquake i : earthquakeArray) {   
      i.draw();   
  }
  
  for (int i=0; i< earthquakeArray.length; i++){
      if(earthquakeArray[i].mouseOver){
        //amountOver;
        //wordWidth = earthquakeArray[i].locationWidth ++ ; 
        
        earthquakeArray[i].writeLocation();
      }
   
  }
  

  //arrow
  arrowX = 0 - 30;
  arrowY = -radius -15;
  //if mouse is on arrow
  if (mousePX>arrowX && mousePX<arrowX+30 && mousePY>arrowY && mousePY<arrowY+30) {
    //if mouse is clicked
    if (mousePressed) {
      stroke(50);
      ellipse(0, 0, 200, 200);
      rotate(radians(5));
      //radius into sin() angle from origin, y cordinate will b cosine of the angle
      //intersection of line and circle
    }

  }
 // println(mousePY);
  //println(arrowY);
  shape(arrow, arrowX, arrowY, 20, 30);
  //text(caption, 0, -radius -100, width, 10);
}


class Earthquake {
  //properties this class will have:
  //latitude, longtitude, time, mag, duration, place
  float magnitude;
  PVector pos;
  PVector originalPos;
  String latitudeStr;
  String longitudeStr;
  String position;
  String location;
  String month;
  int day;
  int hour;
  int minutes;
  int seconds;
  int timeInSec;
  float timeColor;
  float convertedTime;
  float a=0;
  float viewsz;
  boolean mouseOver;
  float locationWidth;
  Earthquake(float latitude, float longitude, String time, float mag, String place, float sz) { //constructor
    pos = new PVector(map(longitude, -180.0, 180.0, -width/2 + margin, width/2 - margin), -(map(latitude, -90.0, 90.0, -height/2 + margin, height/2 - margin)));
    magnitude = map(mag, -1, 10, 0, 50);
    latitudeStr = str(latitude);
    longitudeStr = str(longitude);
    position = latitudeStr + ", " + longitudeStr;
    //println(time);
    month = time.substring(5,7);
    day = int(time.substring(8,10));
     //println(day);
    hour = int(time.substring(11, 13));
    //println(hour);
    minutes = int(time.substring(14, 16));
    //println(minutes);
    seconds = int(time.substring(17, 19));
    //println(seconds);
    timeInSec = (day-1)*24*60*60 + seconds + minutes*60 + hour*60*60;
    convertedTime = map(timeInSec, 0,30*24*60*60, 0, 360);
       //println(convertedTime);
    location = place;
    viewsz = sz;
    locationWidth = textWidth(location);
   boolean mouseOver = false;
    originalPos = new PVector(pos.x, pos.y);
    
  }
  //methods this class will have
  void draw() {
   // println(angle);
    if (convertedTime < angle){
      timeColor = map(convertedTime, 0, 360, 30, 140);
      noStroke();
      //check hover
      if (dist(mousePX, mousePY, pos.x, pos.y)<10) {
        mouseOver = true;
        //writeLocation(mouseOver);
      }else{
        mouseOver = false;
      }
      
      noFill();
      stroke(0,80,0,70);
      strokeWeight(2);
      ellipse(pos.x, pos.y, 5, 5);

      for (float i=magnitude; i>-1; i-=5) {
        strokeWeight(1);
       // stroke(map(i,0,50,100,360),100,100,70); /old green and blue colors
       //noStroke();
       stroke(map(i,1,30,220,360),60,80,60); // rainbow colors
        ellipse(pos.x, pos.y, (sin(a)*i) + incr, (sin(a)*i) + incr);
         //println(incr);
        if(mouseOver){
          a += .03;
        }else{
           a += .01;
        }
      }
    }
  //mouseOver = false;
  }
  
  void writeLocation(){
    if(mouseOver){
      fill(0, 0, 100);
      textSize(12);
      text(location, pos.x, pos.y -5);  
      caption += "Earthquake in: " + location;
    }    
  }
}

void mouseDragged() {
  if (mouseX > pmouseX) {
    rotateVal+= 1; 
    
  } else if (mouseX < pmouseX) {
    rotateVal-= 1;
  }
// to pan
/*float dx = mouseX-pmouseX;
float dy = mouseY - pmouseY;
scaleCenter.x += dx;
scaleCenter.y += dy;*/

float worldX = mouseX - scaleCenter.x;
float worldY = mouseY - scaleCenter.y;


}
 
void scaleAroundPoint(Earthquake i, float statx, float staty, float scl){

  println(i.originalPos.x);
  if(scl == 1.05){
      PVector transform = new PVector((statx - i.pos.x) * scl, (staty - i.pos.y) * scl);
      i.pos.x = statx - transform.x;
      i.pos.y = staty - transform.y;
      i.viewsz *= scl;
  }else if(scl == .95 && incr > 0) {
      PVector transform = new PVector((statx - i.pos.x) * scl, (staty - i.pos.y) * scl);
      i.pos.x = i.pos.x - ((statx - transform.x - i.originalPos.x)/incr);
      i.pos.y = i.pos.y - ((staty - transform.y - i.originalPos.y)/incr);
      i.viewsz *= scl;
  }
 // println(i.viewsz);
}

void keyPressed(){
  float scl = 1;
  
  if(keyCode == UP){
    scl = 1.05;
    incr += 1;
   // println(scl);
  }else if (keyCode == DOWN && incr >= 0){
     scl = .95;
     incr -= 1;
    // println(scl);
  }
  
  
  for (Earthquake i: earthquakeArray){
    scaleAroundPoint(i, mouseX - scaleCenter.x, mouseY - scaleCenter.y, scl);
  }
}

//zoom code based off:  http: forum.processing.org/one/topic/zoom-in-out-is-not-smooth.html



