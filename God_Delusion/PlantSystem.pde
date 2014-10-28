class PlantSystem {
  ArrayList<Plant> plants;
  ArrayList<Plant> deadPlants;
  int limit; 
  boolean poisonous;
  float poisonProb;
  
  PlantSystem(){
    plants = new ArrayList<Plant>();
    deadPlants = new ArrayList<Plant>();
    limit = 0;
    
  }
  
  void run(){
    addPlant();
    Iterator<Plant> pit = plants.iterator();
    while(pit.hasNext()){
      Plant p = pit.next();
      p.run();
      if (p.isDead()){
        pit.remove();
        limit -= 1;
        deadPlants.add(p);
      }
    }
  }
  void addPlant(){
    if (limit < psSize){
      float r = random(1);
      if (r < poisonProb){ // % chance of plant being poisonous to boids
        plants.add(new Plant(random(width), random(height), true));
      } else {
        plants.add(new Plant(random(width), random(height),false));
      }
      limit += 1;
    }
  }
  
  
}
