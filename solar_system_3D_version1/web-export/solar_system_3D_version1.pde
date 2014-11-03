
Sun sun;
ArrayList <Planet> planets; //Array list of Planets
Asteroid [] asteroids; //asteroid belt
float theta = 0.0;
int zoom = 35;
int left = 1;
float eyeX,eyeY,eyeZ;
float centerX,centerY,centerZ;
boolean manCam = false; //Manual Camera controlled by mouse
PFont f;
boolean help;
void setup() {
  size(1200,600,P3D);
  eyeX = (width/2)/1.5;
  eyeY = (height/2)/2.5;
  centerX = width/2;
  centerY = height/2;
  centerZ = 0;
  f=createFont("Arial",24,true);
  smooth();
  sun = new Sun(50,0.0001);
  asteroids = new Asteroid[100];
 
  for (int i = 0; i < asteroids.length; i++){
    asteroids[i] = new Asteroid(random(700,950), random(0.2,5), 0.8, 20, 25,0.0003);
  }
  
  
  planets = new ArrayList <Planet>();
  planets.add(new Planet(90,2.8,0.6,0, #FF0000, false)); //mercury
  planets.add(new Planet(177,4.75,0.3,0,#FFD119, false)); //venus
  planets.add(new Planet(240,5,0.08,1, #00E600, false)); //earth
  planets.add(new Planet(405,3.0,0.04,2, #CF2900, false)); //Mars
  planets.add(new Planet(1209,27.5,0.008,4, #FF6600, false)); //Jupiter
  planets.add(new Planet(2418,23.5,0.002,9, #FFFF66, true)); //Saturn
  planets.add(new Planet(4800,10,0.0009,6, #009933, true)); //Uranus
  planets.add(new Planet(8400,7,0.0002,2, #0029A6, false)); //Neptune
  planets.add(new Planet(9000,2.8,0.0001,1, #DD33CC, false)); //Pluto
  help = true;
  
  
   addMouseWheelListener(new java.awt.event.MouseWheelListener()
  {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt)
    {
      zoom = constrain(zoom - evt.getWheelRotation(), 1, 100);
    }
  });
  
  
  }


void draw(){
  background(0);
  if (help) {
    textAlign(CENTER);
    textFont(f);
    text("A Simple and Slightly Inaccurate 3D Model of The Solar System", width/2-width/8,height/6,width/4,400);
    textFont(f, 16);
    text("Click and then use the mouse to change camera angles. You can also use the mouse wheel or the arrow keys to zoom in or out. Press the space bar to take a screen-shot",width/2-width/8,height/2,width/4,400);
    textFont(f,30);
    text("Press Enter to Start!",width/2-width/8,height/2+height/3,width/4,200);
  }
  else {
  eyeZ = -map(zoom, 100, 1, -9500, 9500);
  manualCamera();
  camera(eyeX, eyeY, eyeZ,
  centerX, centerY, centerZ, //centerx, centerY, centerZ
  0.0,1.0,0.0); //upX,upY, upZ
  println(zoom);
  //draw the sun as an independent
  pushMatrix();
  sun.update();
  sun.display();

  //draw all planets
  for (int i = 0; i < planets.size(); i++){
    Planet planet = planets.get(i);
    planet.update();
    pushMatrix();
    planet.display();
    for (int j = 0; j < planet.moons.length; j++) {
      planet.moons[j].update();
      planet.moons[j].display();
     }
     
     popMatrix();
  }
  
  for (int k = 0; k < asteroids.length; k++) {
    asteroids[k].draw();
  }
  
  popMatrix();
  }
}

void keyPressed(){
  if (key == CODED) {
  if (keyCode == UP) { 
    zoom+=1;
  }
  else if (keyCode == DOWN) {
    zoom-=1;
  }
  }
  if (key == ENTER) {
    help = false;
  }
  if (key == ' ') {
    saveFrame("file####.jpg");
  }
  if (key == 'p' || key == 'P') {
    pause = !pause;
  }
  
}

void mousePressed(){
  manCam = !manCam;
}

void manualCamera(){
    if (manCam){
    eyeX = mouseX*1.5;
    eyeY = mouseY*2.5;
    } else {
    eyeX = (width/2)/1.5;
    eyeY = (height/2)/2.5;
  }
  
}


class Ring{
  float diameter;


  
  Ring(float diameter_){
    
    diameter = diameter_;
   
  }
  
  void display() {
    rotateY(theta);
    strokeWeight(1);
    noFill();
    ellipse(0,0,diameter,diameter);
  }  
}
class Moon extends Planet {

  Moon(float distance_, float diameter_, float orbitSpeed_, int moons_, color surface_, boolean ring_){
    super(distance_, diameter_, orbitSpeed_, moons_, surface_, ring_);
    theta = 0;
    theta2 = 0;
    orbitSpeed = orbitSpeed_;
    dayLength = random(0.0001,0.1);
  }
  
  
  
  void display(){
    pushMatrix();
      rotateY(theta); //rotate orbit
      translate(distance,0); //translate out distance
      rotateY(theta2);
      noStroke();
      lights();
      fill(100);
      sphere(diameter);
    popMatrix();
  }
}

class Planet {
  float theta; //orbit round sun speed
  float theta2; //spin speed
  float diameter;
  float distance;
  float orbitSpeed;
  float dayLength;
  color surface;
  boolean planetRing;
  Moon[] moons;
  Ring [] rings; //planet rings
  
  
  Planet(float distance_, float diameter_, float orbitSpeed_, int moons_, color surface_, boolean planetRing_){
    distance = distance_;
    diameter = diameter_;
    surface = surface_;
    planetRing = planetRing_;
    theta = random(0,5);//space out planet orbits otherwise they all start at same point
    theta2 = 0;
    orbitSpeed = orbitSpeed_;
    dayLength = random(0.0001,0.1);
    moons = new Moon[moons_];
    for (int i = 0; i < moons.length; i++){
    moons[i] = new Moon(random(diameter*3,diameter*5),random(diameter/10,diameter/8), random(0.0003,0.5),0, 0, false);
    } 
    if (planetRing){
      rings = new Ring[30];
      float ringDiam = diameter/2;
      for (int j = 0; j < rings.length; j++){
        rings[j] = new Ring(diameter*2+ringDiam);
        ringDiam += 2;
        
      }
    }
  }
    void update() {
      //increment angle of rotation
      theta += orbitSpeed;
      theta2 += dayLength;
    }
    
    void drawOrbit() {
      stroke(255,100);
      pushMatrix();
      for (int i = 0; i < 360; i++){
        rotateY(1.0); //orbit already drawn when program starts
        point(distance,0);
       
      }
      popMatrix();
    }
    
    void drawRing(){
      pushMatrix();
      rotateX(PI/2);
      stroke(surface,20);
      for (int i = 0; i < rings.length; i++){
        rings[i].display();
    }
    popMatrix();
    }
    
    void display() {
      drawOrbit();
      rotateY(theta); //rotate orbit
      translate(distance,0); //translate out distance
      if (planetRing){
        drawRing();
      }
      rotateY(theta2); //rotate dayspeed
      noStroke();
      lights();   
      fill(surface);
      sphere(diameter);
    }
}

class Sun {
  float theta;
  float diameter, spin;
  
  Sun(float diameter_, float spin_){
   diameter = diameter_;
   spin = spin_;
   theta = 0; 
  }
  
  void update() {
    theta += spin;
  }
      
  void display() {
  translate(width/2,height/2);
  lights();
  fill(random(200,255),random(180,200),0);
  rotateY(theta);
  sphere(diameter);
  theta += 0.01;
  }
  
}

