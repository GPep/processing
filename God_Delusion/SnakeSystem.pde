class SnakeSystem extends Flock {
  ArrayList<Snake> snakes;
  int newSnakes;
  
  SnakeSystem(){
    snakes = new ArrayList<Snake>();
    newSnakes = 0;
  }
  
  void run(){
    giveBirth(random(width),random(height));
    Iterator<Snake> it = snakes.iterator();
    while(it.hasNext()){
      Snake s = it.next();
      s.run(snakes);
      if (s.isDead()){
        it.remove();
        println("Snake died!");
      }
    }
    for (Snake s: snakes){
      if (s.g.pregnant){
        newSnakes += 1;
        s.g.pregnant = false;
      }
    }
  }
  
  void giveBirth(float x, float y){
    for (int i = 0; i <= newSnakes; i++){
      snakes.add(new Snake(x,y));
      newSnakes -= 1;
    }
  }
  
  void addSnake(float x, float y){
      snakes.add(new Snake(x,y));
  }
  
  float getAverageAge(){
    float totalAge = 0;
    float averageAge = 0;
    for (Snake s: snakes){
      totalAge += s.g.lifespan;
      
    }
    averageAge = totalAge / snakes.size();
   return averageAge; 
  }
}

