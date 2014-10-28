class Flock {
  ArrayList<Boid> boids;
  int newBoids;
  
  Flock(){
    boids = new ArrayList<Boid>();
    newBoids = 0;
  }
  
  void run(){
    giveBirth(random(width),random(height));
    Iterator<Boid> it = boids.iterator();
    while(it.hasNext()){
      Boid b = it.next();
      b.run(boids);
      if (b.isDead()){
        it.remove();
      }
    }
    for (Boid b: boids){
      if (b.g.pregnant){
        newBoids += 1;
        b.g.pregnant = false;
      }
    }
  }
  
  void giveBirth(float x, float y){
    for (int i = 0; i <= newBoids; i++){
      boids.add(new Boid(x,y));
      newBoids -= 1;
    }
  }
  
  void addBoid(float x, float y){
      boids.add(new Boid(x,y));
  }
  
  float getAverageAge(){
    float totalAge = 0;
    float averageAge = 0;
    for (Boid b: boids){
      totalAge += b.g.lifespan;
      
    }
    averageAge = totalAge / boids.size();
   return averageAge; 
  }
}
