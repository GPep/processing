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

