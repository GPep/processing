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

