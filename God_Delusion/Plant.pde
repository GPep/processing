class Plant{
  PVector location;
  float r;
  boolean active;
  boolean poisonous;
  PGenetics g;
  
   Plant(float x, float y, boolean p_){
    location = new PVector(x,y);
    r = 3;
    g = new PGenetics();
    active = false;
    poisonous = p_;
  }
  
  void run(){
    if (r > 5 || g.lifespan > 25){
      active = true;
    } else {
      active = false;
    }
    lifecycle();
    display();
    g.updateGenetics();
  }
  
  void display(){
    stroke(0,255,50);
    if (poisonous){
      fill(150,0,0,200);
    } else {
      fill(0,150,50,200);
    }
    pushMatrix();
    translate(location.x, location.y);
    ellipse(0,0,r*2,r*2);
    popMatrix();
  }
  
  boolean eaten(PVector prey){
    if (prey.x < location.x + r*2 && prey.x > location.x - r*2 && prey.y < location.y + r*2 && prey.y > location.y - r){
      r -= 0.01;
      g.lifespan += 0.05;
      return true;
    } else {
      return false;
    }
  }
  
  void lifecycle(){
    r = constrain(r,0,25);
    if (poisonous){
      g.lifespan += g.ageSpeed;
      r+= 0.05;
    } else {
      g.lifespan += g.ageSpeed;
      r += 0.05;
    }
  }
  
  Boolean isDead(){
   if (g.lifespan >= 100.0 || r < 3){
     return true;
     } else {
       return false;
     }
   }   
  
}
