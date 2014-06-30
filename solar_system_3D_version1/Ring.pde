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
