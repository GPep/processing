class Snake {
  PVector location;
  PVector velocity;
  PVector acceleration;
  SGenetics g;
  float r;
  float wandertheta;
  float[] xpos = new float[50];
  float[] ypos = new float[50];
  
  
  Snake(float x,float y){
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 6;
    g = new SGenetics();
    for (int i = 0; i < xpos.length; i++){
      xpos[i] = 0;
      ypos[i] = 0;
    }
  }
  
  void run(ArrayList<Snake> snakes){
    lifeCycle();
    update();
    borders();
    display();
    if (g.hungry) {
      g.speed = g.fleeSpeed;
      g.force = g.fleeForce;
      detect(flock.boids);
    }
    else if (g.fertility >= 100 && g.lifespan < 60){
        flock(snakes);
   } else {
      g.speed = 1;
      g.force = 0.1;
      wander();
    }
    PVector sep = separate(snakes);
    sep.mult(1.0);
    applyForce(sep);
    g.updateGenetics();
  }
  
  void applyForce(PVector force){
    acceleration.add(force);
  }
  
  void wander() {
    float wanderR = 1;         // Radius for our "wander circle"
    float wanderD = 400;         // Distance for our "wander circle"
    float change = 0.3;
    wandertheta += random(-change,change);     // Randomly change wander theta

    // Now we have to calculate the new location to steer towards on the wander circle
    PVector circleloc = velocity.get();    // Start with velocity
    circleloc.normalize();            // Normalize to get heading
    circleloc.mult(wanderD);          // Multiply by distance
    circleloc.add(location);               // Make it relative to boid's location
    
    float h = velocity.heading2D();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h),wanderR*sin(wandertheta+h));
    PVector target = PVector.add(circleloc,circleOffSet);
    PVector destination = seek(target);
    destination.limit(g.speed);
    applyForce(destination);
  }  
  
  
  void flock(ArrayList<Snake> snakes){
    PVector sep = separate(snakes);
    sep.mult(1.0);
    applyForce(sep);

    PVector coh = cohesion(snakes);
    coh.mult(5.0);
    applyForce(coh);
    
    PVector ali = align(snakes);
    ali.mult(1.0);
    applyForce(ali);    
  }
  
 
  void detect(ArrayList<Boid> boids) {
    for (Boid b : boids){
        float targetDist = g.senseFoodDistance; // only detect food within this distance
        float d = PVector.dist(b.location, location);
        if (d < targetDist){
          PVector desired = PVector.sub(b.location, location);
          desired.normalize();
          desired.mult(g.speed*(b.g.energy+b.g.lifespan)); //pick off the most vulnerable boids first
          desired.sub(velocity);
          desired.limit(g.force);
          applyForce(desired);
          if (b.eaten(location)){
            eat(b.location);
          }
    }
    }
  } 
  
  PVector seek(PVector target){
    PVector desired = PVector.sub(target,location);
    float d = desired.magSq()/10;
    desired.normalize();
    if (d < 50) { //slow down when approaching
      float m = map(d,0,100,0,g.speed);
      desired.mult(m);
    } else {
      desired.mult(g.speed);
    }
    desired.sub(velocity);
    desired.limit(g.force);
    return desired;
  }

  PVector cohesion(ArrayList<Snake> snakes){
    float neighbourDist = g.cohesionDistance;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Snake other : snakes){
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbourDist)){
        sum.add(other.location);
        count++;
      }
    }
    if (count > 0){
      sum.div(count);
      //reproduce if fertility is at 100
    if (g.fertility >= 100){
        reproduce(snakes);
      }
      return seek(sum);
    } else {
      return new PVector(0,0);
    }
  }
  
  PVector separate(ArrayList<Snake> snakes){
    int count = 0;
    float desiredSeparation = r*2;
    PVector sum = new PVector();
    PVector diff = new PVector();
    for (Snake other: snakes){
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < desiredSeparation)){
        diff.x = location.x;
        diff.y = location.y;
        diff.sub(other.location);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    if (count > 0){
      sum.div(count);
      sum.setMag(g.speed);
      sum.sub(velocity);
      sum.limit(g.force);
      return sum;
    } else {
      return new PVector(0,0);
    }
  }
  
  PVector align(ArrayList<Snake> snakes){
    float neighbourDist = 50; //only calculate average based on other boids within this distance
    PVector sum = new PVector(0,0);
    int count = 0;
    //add up all velocities and calculate average
    for (Snake other : snakes){
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbourDist)){
      sum.add(other.velocity);
      count++;
      }
    }
    if (count > 0){
      sum.div(count); //only calculate average based on number of boids within distance
      sum.normalize();
      sum.mult(g.speed);
      
      sum.sub(velocity);
      sum.limit(g.force);
      return sum;
    } else {
      return new PVector(0,0);
    }
  }
  
  void lifeCycle(){
    g.lifespan = constrain(g.lifespan,0,100);
    g.lifespan += g.ageSpeed;
    g.energy -= g.tireSpeed;
    g.fertility += g.fertilitySpeed;
    if (g.energy < 60){
      g.hungry = true;
    } else {
      g.hungry = false;
    }
  }
  
  void eat(PVector target) {
     g.energy += g.replenish;
  }
  
  void reproduce(ArrayList<Snake> snakes){
    float neighbourDist = 50;
    if (random(1)<0.10){ //There is a 10% chance of mating
    for (Snake other : snakes){
      float d = PVector.dist(location, other.location);
      if (d <= neighbourDist && d > 0) {
        g.pregnant = true;
        g.energy -= 15; //energy taken to reproduce
      }

    }
      g.fertility = 0;
    }

  }
  
  void borders(){
    if (location.x - r*2 > width - r*2){location.x = r*2;}
    if (location.x + r*2 < 0){location.x = width-r*2;}
    if (location.y-r*2 > height){location.y = r*2;}
    if (location.y + r*2< 0){location.y = height-r*2;}
  }
  
  void update(){
    velocity.add(acceleration);
    velocity.limit(g.speed);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display(){
    for(int i = 0; i < xpos.length-1; i++) {
      xpos[i] = xpos[i+1];
      ypos[i] = ypos[i+1];
    }
    xpos[xpos.length-1] = location.x;
    ypos[ypos.length-1] = location.y;
    float age = map(g.lifespan, 0,100,255,0);
    fill(175,25,0,age);
    stroke(0,age);
    pushMatrix();

    for (int i = 0; i < xpos.length; i++){
    ellipse(xpos[i],ypos[i],r*2,r*2);
    }
    popMatrix();
  }
  
  boolean isDead(){
     if (g.lifespan >= 100.0 | g.energy <= 0) {
       return true;
     } else {
       return false;
     }
   }
    
    
}

