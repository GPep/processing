class Sun {
  float theta;
  float diameter, spin;
  
  Sun(float diameter_, float spin_){
   diameter = diameter_;
   spin = spin_;
   theta = 0; 
  }
  
  void update() {
    theta += spin;
  }
      
  void display() {
  translate(width/2,height/2);
  lights();
  fill(random(200,255),random(180,200),0);
  rotateY(theta);
  sphere(diameter);
  theta += 0.01;
  }
  
}
