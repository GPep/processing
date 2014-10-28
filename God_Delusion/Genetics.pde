class PDefault {
  float ageSpeed, poisonProb;
  
  PDefault() {
    ageSpeed = 0.05;
    poisonProb = 0.20; //20% chance of being poisonous
    
  }
}


class PGenetics {
  float lifespan;
  float ageSpeed;
  float poisonProb;
  
  PGenetics() {
    lifespan = 0;
    ageSpeed = 0.05;
    poisonProb = 0.20;
  }
  
  void updateGenetics(){
    updateParameters();
  }
  
  void updateParameters(){
    ageSpeed = pGui.pAgeSpeed;
    ps.poisonProb = pGui.poisonProb;
  }
  
}
    
class BDefault {
    float tireSpeed, ageSpeed, speed, force, fleeSpeed, fleeForce,fertilitySpeed, replenish, cohStrength,sepStrength, aliStrength;
    
    BDefault(){
      speed = 1.0;
      force = 0.1;
      fleeSpeed = 3.0;
      fleeForce = 0.5;
      ageSpeed = 0.02;
      tireSpeed = 0.04;
      fertilitySpeed = 0.1;
      replenish = 1.5;
      cohStrength = 1.5;
      sepStrength = 1.0;
      aliStrength = 1.0;     
    }
}    

class Genetics {
  float speed, force;
  float fleeSpeed, fleeForce; //speed to flee threats
  float lifespan;
  float energy;
  float tireSpeed, ageSpeed, fertilitySpeed, replenish;
  float poisonAge, poisonEnergy;
  boolean pregnant, hungry;
  float fertility;
  float cohesionDistance;
  float senseFoodDistance; 
  float senseThreatDistance;
  float cohStrength,sepStrength, aliStrength;
  ArrayList<PVector> inedible = new ArrayList();
  ArrayList<PVector> edible = new ArrayList();
  float fearFactor; //fear level
  BDefault bd;

  
  
  Genetics(){
    bd = new BDefault();
    speed = bd.speed;
    force = bd.force;
    fleeSpeed = bd.fleeSpeed;
    fleeForce = bd.fleeForce;
    lifespan = 0;
    energy = 100;
    ageSpeed = bd.ageSpeed;
    tireSpeed = bd.tireSpeed;
    poisonAge = 20;
    poisonEnergy = 40;
    fertilitySpeed = bd.fertilitySpeed;
    pregnant = false;
    fertility = 0;
    inedible = new ArrayList<PVector>();
    edible = new ArrayList<PVector>();
    hungry = false;
    senseFoodDistance = 150;
    senseThreatDistance = 50;
    cohesionDistance = 50;
    fearFactor = 0;
    replenish = bd.replenish;
    cohStrength = bd.cohStrength;
    sepStrength = bd.sepStrength;
    aliStrength = bd.aliStrength;

  }
  
  void updateGenetics(){
    if (lifespan > 60){
      speed = 0.5;
      fleeSpeed = 0.5;
      fleeForce = 0.01;
      fearFactor += 75;
    }
    if (energy < 20){
      speed = 0.5;
      fleeSpeed = 0.5;
      fleeForce = 0.01;
      fearFactor += 75;
    }
    if (fearFactor > 75){ //heighten awareness of danger
      senseThreatDistance = 150;
      cohesionDistance = 500;
    } else {
      senseThreatDistance = 50;
      cohesionDistance = 50;
    }
    
    updateParameters();
  }
  
  void updateParameters(){
    speed = bGui.bSpeed;
    force = bGui.bForce;
    fleeSpeed = bGui.bFleeSpeed;
    fleeForce = bGui.bFleeForce;
    tireSpeed = bGui.bTireSpeed;
    ageSpeed = bGui.bAgeSpeed;
    fertilitySpeed = bGui.bFertilitySpeed;
    replenish = bGui.bReplenish;
    cohStrength = bGui.bCohStrength;
    sepStrength = bGui.bSepStrength;
    aliStrength = bGui.bAliStrength;    
  }

}

class SDefault {
  float speed, force, fleeSpeed, fleeForce, tireSpeed, ageSpeed, fertilitySpeed, replenish;
  
  SDefault() {
    speed = 1.0;
    force = 0.1;
    fleeSpeed = 4.0;
    fleeForce = 1.0;
    ageSpeed = 0.01;
    tireSpeed = 0.04;
    fertilitySpeed = 0.1;
    replenish = 12.0;
  }
}

class SGenetics {
  float speed, force;
  float fleeSpeed, fleeForce; //speed to flee threats
  float lifespan;
  float energy;
  float tireSpeed, ageSpeed, fertilitySpeed, replenish;
  float poisonAge, poisonEnergy;
  boolean pregnant, hungry;
  float fertility;
  float cohesionDistance;
  float senseFoodDistance; 
  float senseThreatDistance;
  ArrayList<PVector> inedible = new ArrayList();
  ArrayList<PVector> edible = new ArrayList();
  float fearFactor; //fear level
  SDefault sd;

  
  SGenetics(){
    sd = new SDefault();
    speed = sd.speed;
    force = sd.force;
    fleeSpeed = sd.fleeSpeed;
    fleeForce = sd.fleeForce;
    lifespan = 0;
    energy = 100;
    ageSpeed = sd.ageSpeed;
    tireSpeed = sd.tireSpeed;
    fertilitySpeed = sd.fertilitySpeed;
    pregnant = false;
    fertility = 0;
    inedible = new ArrayList<PVector>(); //not using at moment but may do in future
    edible = new ArrayList<PVector>();
    hungry = false;
    senseFoodDistance = 150;
    senseThreatDistance = 50;
    cohesionDistance = 400;
    fearFactor = 0;
    replenish = sd.replenish;

  }
  
  
  void updateGenetics(){
    if (lifespan > 90){
      speed = 0.5;
      fleeSpeed = 3.0;
      fleeForce = 0.01;
    }
    if (energy < 10){
      speed = 0.5;
      fleeSpeed = 3.0;
      fleeForce = 0.01;
    }    
    updateParameters();
  
  }
  
  
  void updateParameters(){
    tireSpeed = sGui.sTireSpeed;
    ageSpeed = sGui.sAgeSpeed;
    fertilitySpeed = sGui.sFertilitySpeed;
    replenish = sGui.sReplenish;
  }
  
}
