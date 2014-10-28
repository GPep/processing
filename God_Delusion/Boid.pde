class Boid {
  PVector location;
  PVector velocity;
  PVector acceleration;
  Genetics g;
  float r;
  float wandertheta;
  String title;

  
  Boid(float x, float y){
    acceleration = new PVector(random(-1,1),random(-1,1));
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    title = "Boid";
    g = new Genetics();
    r = 3.0;
    wandertheta = 0;
  }
  
  void run(ArrayList<Boid> boids){
    update();
    borders();
    display();
    behaviour(boids);
    lifeCycle();
    learn(boids);
    g.updateGenetics();
    
  }
  
  void borders(){
    if (location.x - r*2 > width - r*2){location.x = r*2;}
    if (location.x + r*2 < 0){location.x = width-r*2;}
    if (location.y-r*2 > height){location.y = r*2;}
    if (location.y + r*2< 0){location.y = height-r*2;}
  }
  
  void update(){
    velocity.add(acceleration);
    //velocity.limit(g.speed);
    location.add(velocity);
    acceleration.mult(0);
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
  
  void behaviour(ArrayList<Boid> boids){
    
    forget(ps.deadPlants); //forget positions of all plants that are now dead
    //Avoid predators
    PVector flee = new PVector();
    for (Snake s : ss.snakes){
      flee = avoid(s.location);
      flee.mult(1.0);
      applyForce(flee);
    }
    //hungry
    if (g.hungry && g.fearFactor < 75){
      detectFood(ps.plants);
    }
    else if (!g.hungry && g.lifespan < 60 && g.fertility >= 100){
       flock(boids);
    }
    else if (g.fearFactor >= 75){ 
      flock(boids); //safety in numbers
      } else {
        wander();
        PVector sep = separate(boids);
        sep.mult(1.0);
        applyForce(sep);
      }
     // avoid poisonous plants
    for (PVector yuk: g.inedible){
      PVector ignore = avoid(yuk);
      ignore.mult(1.0);
      applyForce(ignore);
    }
  }
    
  
  void flock(ArrayList<Boid> boids){

      PVector coh = cohesion(boids); 
      PVector sep = separate(boids);
      PVector ali = align(boids);
      
      coh.mult(g.cohStrength);
      sep.mult(g.sepStrength);
      ali.mult(g.aliStrength);
      
      applyForce(coh);
      applyForce(sep);
      applyForce(ali);
  }

  
  PVector separate(ArrayList<Boid> boids){
    int count = 0;
    float desiredSeparation = r*4;
    PVector sum = new PVector();
    PVector diff = new PVector();
    for (Boid other: boids){
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
  void detectFood(ArrayList<Plant> plants) {
    for (Plant p : plants){
      if (g.inedible.contains(p.location)){
        PVector flee = avoid(p.location);
        flee.mult(1.0);
        applyForce(flee);
      } else {
      if (p.active){
        float targetDist = g.senseFoodDistance; // only detect food within this distance
        float d = PVector.dist(p.location, location);
        if (d < targetDist){
          PVector desired = PVector.sub(p.location, location);
          float approach = desired.mag();
          desired.normalize();
          if (approach < 75){ //slow down as approaching food
            float m = map(approach,0,100,0,g.speed);
            desired.mult(m);
            } else {
            desired.mult(g.speed*(p.r+p.g.lifespan));
            }
          desired.sub(velocity);
          desired.limit(g.force);
          applyForce(desired);
          if (p.eaten(location)){
            eat(p.location, p.poisonous);
          }
        }
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
    
  PVector align(ArrayList<Boid> boids){
    float neighbourDist = 50; //only calculate average based on other boids within this distance
    PVector sum = new PVector(0,0);
    int count = 0;
    //add up all velocities and calculate average
    for (Boid other : boids){
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
  
  PVector cohesion(ArrayList<Boid> boids){
    float neighbourDist = g.cohesionDistance;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Boid other : boids){
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbourDist)){
        sum.add(other.location);
        count++;
      }
    }
    if (count > 0){
      sum.div(count);
      if (g.fertility >= 100){
      reproduce(boids);
      }
      return seek(sum);
    } else {
      return new PVector(0,0);
    }
  }
  
  PVector avoid(PVector predator){
    g.fearFactor = constrain(g.fearFactor,0,100);
    float targetDistance = dist(location.x, location.y, predator.x, predator.y);
    if (targetDistance < g.senseThreatDistance){
    PVector desired = PVector.sub(predator, location);
    desired.normalize();
    desired.mult(-1*g.fleeSpeed); //multiply by -1
    desired.sub(velocity);
    desired.limit(g.fleeForce);
    g.fearFactor += 10;
    return desired;

    } else {
      g.fearFactor -= 0.5;
      return new PVector(0,0);

    }
  }
  
  void learn(ArrayList<Boid> boids){ //teach other boids where poisonous plants are
    float neighbourDist = 50;
    for (Boid other : boids){
      float d = PVector.dist(location, other.location);
      if (d <= neighbourDist && d > 0){
         for (PVector yuk : g.inedible){ //learn new locations
            if (!other.g.inedible.contains(yuk)){
              other.g.inedible.add(yuk);
            }
         }

      }
    }
  }
  
  void forget(ArrayList<Plant> deadPlants){ //forget location of all dead plants
    for (Plant old: deadPlants){
      if (g.inedible.contains(old.location)){
        g.inedible.remove(old);
      }
    }
  }
  
  void eat(PVector target, boolean poison) {
    if (poison){
      g.lifespan += g.poisonAge;
      g.energy -= g.poisonEnergy;
      g.inedible.add(target);
    } else {
     g.energy += g.replenish;
     g.edible.add(target);
    }
  }
  
  void reproduce(ArrayList<Boid> boids){
    float neighbourDist = 20;
    //if (random(1)<0.40){ //only reproduce if energy levels at 75% and boid is not too old AND there is 40% chance of mating
    for (Boid other : boids){
      float d = PVector.dist(location, other.location);
      if (d <= neighbourDist && d > 0) {
        g.pregnant = true;
        g.energy -= 25; //energy taken to reproduce
        g.fertility = 0; //reset fertility to zero - boid can only give birth when this is at 100
      }

    }
    //}
    

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
  
  void display(){
    float theta = velocity.heading() + PI/2;
    float age = map(g.lifespan, 0,100,255,0);
    fill(175,75,180,age);
    stroke(0,age);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0,-r*2);
    vertex(-r,r*2);
    vertex(r,r*2);
    endShape(CLOSE);
    popMatrix();
  }
  
  boolean isDead(){
     if (g.lifespan >= 100.0 | g.energy <= 0) {
       return true;
     } else {
       return false;
     }
   }
   
  boolean eaten(PVector prey){
    if (prey.x < location.x + r*2 && prey.x > location.x - r*2 && prey.y < location.y + r*2 && prey.y > location.y - r){
      g.lifespan = 100;
      g.energy = 0;
      return true;
    } else {
      return false;
    }
  } 
}

