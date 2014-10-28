Flock flock;
PlantSystem ps;
SnakeSystem ss;
import controlP5.*;
ControlP5 cp5;
ControlP5 Mcp5;
ControlP5 Bcp5;
import java.util.Iterator;
PFont f;
Buttons buttons;
MainGui mainGui;
GeneGui bGui;
SGeneGui sGui;
PGeneGui pGui;
boolean gameOn;
int psSize, ssSize, flockSize;
boolean showMenu = true;


void setup(){
  size(800,600);
  smooth();
  psSize = 6;
  ssSize = 3;
  flockSize = 25;
  cp5 = new ControlP5( this ); //system parameters
  Mcp5 = new ControlP5(this); // main parameters
  Bcp5 = new ControlP5(this); //buttons - these are always visible
  f = createFont("Georgia",16,true);
  flock = new Flock();
  ss = new SnakeSystem();
  ps = new PlantSystem();
  for (int p = 0; p < psSize; p++){
    ps.addPlant();
  }
  for (int s = 0; s < ssSize; s++){
    ss.addSnake(random(width), random(height));
  }
  for (int i = 0; i < flockSize; i++){
    flock.addBoid(random(width), random(height));
  }
  buttons = new Buttons();
  mainGui = new MainGui(flockSize, ssSize, psSize, "No of Boids", "No of Snakes", "No of Plants");
  bGui = new GeneGui("Boid");
  sGui = new SGeneGui("Snake");
  pGui = new PGeneGui("Plant");
  gameOn = false;
}

void draw(){
  //saveFrame("frames/####.png");
  background(150);
  if (gameOn){
  cp5.hide();
  Mcp5.hide();
  flock.run();
  ps.run();
  ss.run();
  fill(0);
  textFont(f);
  float average = flock.getAverageAge();
  float snakeAve = ss.getAverageAge();
  text("Number of Boids: " + flock.boids.size(),10,20);
  text("Average Age: " + int(average),10,40);
  text("Number of Snakes: " + ss.snakes.size(),10,60); 
  text("Average Snake Age: " + int(snakeAve),10,80);
  } else {
    cp5.show();
    Mcp5.show();
  }
}

void keyPressed(){
  if (key == 'r' || key == 'R'){
    restart();  
  }
}

void restart(){
  flock = new Flock();
  ss = new SnakeSystem();
  ps = new PlantSystem();
  for (int s = 0; s < ssSize-1; s++){
    ss.addSnake(random(width), random(height));
  }
  for (int i = 0; i < flockSize-1; i++){
    flock.addBoid(random(width), random(height));
  }
  for (int p = 0; p < psSize-1; p++){
    ps.addPlant();
  }
}

void resetParams(){
  psSize = 6;
  ssSize = 3;
  flockSize = 25;
  mainGui = new MainGui(flockSize, ssSize, psSize, "No of Boids", "No of Snakes", "No of Plants");
  bGui = new GeneGui("Boid");
  sGui = new SGeneGui("Snake");
  pGui = new PGeneGui("Plant");
}

