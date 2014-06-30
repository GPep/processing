import processing.video.*;
//size of each cell in grid
int videoScale = 8; // 640/80 = 8 &amp; 480/80 = 8
int cols, rows;
Capture video;
 
void setup(){
  size(640,480);
  cols = width/videoScale;
  rows = height/videoScale;
  video = new Capture(this,width,height);
  video.start();
}
 
void draw() {
  if (video.available()) {
    video.read();
  }
  video.loadPixels();
 
  //begin loop for columns
  for (int i = 0;i &lt; cols; i++){
    //begin loop for rows
    for (int j = 0; j &lt; rows; j++){
      int x = i*videoScale;
      int y = j*videoScale;
 
      //looking up the appropriate colour in the pixel array
      color c = video.pixels[x+y * video.width];
 
      fill(c);
      stroke(0);
      rect(x,y,videoScale,videoScale);
    }
  }
}
 
void mousePressed() {
  saveFrame("file####.jpg");
}

Posts navigation
← Older posts

