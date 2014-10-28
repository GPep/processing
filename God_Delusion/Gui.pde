

class MainGui {

  int value1;
  int value2;
  int value3;

  MainGui(int _value1, int _value2, int _value3, String s1, String s2, String s3) {
    value1 = _value1;
    value2 = _value2;
    value3 = _value3;

    Mcp5.addTextlabel("Mlabel")
       .setText("Main Parameters")
       .setPosition(560, 5)
       .setColorValue(000)
       .setFont(createFont("Georgia",20))
       ;   

   
    Mcp5.addSlider("value1")
       .setColorCaptionLabel(0)
       .setPosition(560,35)
       .setRange( 1, 50 )
       .plugTo( this, "value1" )
       .setValue( value1 )
       .setLabel(s1)
       .setNumberOfTickMarks(50)
       ;
       
    Mcp5.addSlider("value2")
       .setColorCaptionLabel(0)
       .setPosition(560,55)
       .setRange( 1, 25 )
       .plugTo( this, "value2" )
       .setValue(value2)
       .setLabel(s2)
       .setNumberOfTickMarks(25)
       ;
       
    Mcp5.addSlider("value3")
       .setColorCaptionLabel(0)
       .setPosition(560,75)
       .setRange( 1, 25 )
       .plugTo( this, "value3" )
       .setValue( value3)
       .setLabel(s3)
       .setNumberOfTickMarks(25)
       ;
 
    Mcp5.addTextlabel("label")
       .setText("The God Delusion")
       .setPosition(175,50)
       .setColorValue(0xffffff00)
       .setFont(createFont("Georgia",28))
       ;

    Mcp5.addTextarea("txt")
       .setPosition(75,100)
       .setSize(450,445)
       .setFont(createFont("arial",14))
       .setLineHeight(14)
       .setColor(color(0))
       .setColorBackground(color(255,100))
       .setColorForeground(color(255,100))
       .setText("Ever wondered what it would be like to be God. This simulation will sort of allow you to play out that fantasy."
       + " By modifying the parameters on the right, can you make everything coexist? Can you produce other real world trends like famine or population explosions and how does the simulation cope with these events?"
       + " There is no right or wrong way to play this game/simulation and you might be surprised at the varying outcomes by only slightly changing just one parameter by the smallest value."
       + " This simulation is based on an exercise from 'The Nature of Code' by Daniel Shiffman and also Craig Reynolds' studies in developing autonomous objects."
       + " There is currently no scoring system or a way to 'win'. Simply see how long you can make all creatures coexist. The Boids eat the plants and try to evade being eaten by the Snakes"
       + " as well as trying to reproduce. Some plants can be poisonous to Boids but they have enough intelligence to remember where the poisonous plants are (after first having eaten them and becoming ill)"
       + " and to not eat them again. They also have the ability to tell other boids (in close proximity) about the location of the poisonous plants so that they will not try to eat them."
       + " They will also flee any snakes that get too close. Boids will also flock together when they want to reproduce or when they are scared. As they get older, the slower they get and the propensity to flock together increases."
       + " Only the fitter, healthy boids can reproduce and flee prey."
       + " The Snakes eat the Boids and try to reproduce but if there are aren't enough boids for the snakes to feed off or they can't catch them, they will not be able to reproduce and therefore will die. Snakes also only have a 10% chance of"
       + " reproducing with each fertility cycle and also hunt better in a pack"
       + " They will eat the older, weaker boids first." 
       + " Plants will always be able to grow no matter if they are all eaten and die. They can however be poisonous to Boids."
       + " In future versions of this simulation, I hope to introduce disease, weather systems and other species to influence the eco system and the outcome further."
       );
      
  }
  
}

class Buttons{
  
  Buttons(){         
    Bcp5.addButton("Go")
     .setValue(0)
     .setPosition(560,550)
     .setSize(60,40)
     .plugTo( this, "Go" )
     ;

    Bcp5.addButton("Stop")
     .setValue(0)
     .setPosition(630,550)
     .setSize(60,40)
     .plugTo( this, "Stop" )
     ;
     
    Bcp5.addButton("Reset")
     .setValue(0)
     .setPosition(700,550)
     .setSize(60,40)
     .plugTo(this,"Reset")
     .setLabel("Reset")
     ; 
  }
  
  void controlEvent(ControlEvent theEvent) {
    println("control event from : "+theEvent.controller().name());
      if(theEvent.isController()) { 
        if(theEvent.controller().name()=="Go") {
          gameOn = true;
          flockSize = mainGui.value1;
          ssSize = mainGui.value2;
          psSize = mainGui.value3;
          restart();
        }
        if(theEvent.controller().name()=="Stop") {
          gameOn = false;

        }
        if(theEvent.controller().name()=="Reset") {
          resetParams();
          restart();

        }
      }
      
  }
}

class GeneGui {
  float bSpeed, bForce, bFleeSpeed, bFleeForce, bTireSpeed, bAgeSpeed, bFertilitySpeed;
  float bReplenish;
  String bTitle;
  float bCohStrength, bAliStrength, bSepStrength;
  BDefault bd; //default values
  
  GeneGui(String _s){
    bTitle = _s;
    bd = new BDefault();
    bSpeed = bd.speed;
    bForce = bd.force;
    bFleeSpeed = bd.fleeSpeed;
    bFleeForce = bd.fleeForce;
    bTireSpeed = bd.tireSpeed;
    bAgeSpeed = bd.ageSpeed;
    bFertilitySpeed = bd.fertilitySpeed;
    bReplenish = bd.replenish;
    bCohStrength = bd.cohStrength;
    bAliStrength = bd.aliStrength;
    bSepStrength = bd.sepStrength;
    
    cp5.addTextlabel("bTitle")
       .setText(bTitle + " Parameters")
       .setPosition(560, 100)
       .setColorValue(000)
       .setFont(createFont("Georgia",20))
       ;
    
    cp5.addSlider("bSpeed")
       .setColorCaptionLabel(0)
       .setPosition(560,130)
       .setRange(0, 5 )
       .plugTo( this, "bSpeed" )
       .setValue( bSpeed )
       .setLabel("Normal Speed")
       ;
   
    cp5.addSlider("bForce")
       .setColorCaptionLabel(0)
       .setPosition(560,150)
       .setRange(0.1, 0.5 )
       .plugTo( this, "bForce" )
       .setValue( bForce )
       .setLabel("Normal Reaction Speed")
       ;      

    cp5.addSlider("bFleeSpeed")
       .setColorCaptionLabel(0)
       .setPosition(560,170)
       .setRange(1, 8 )
       .plugTo( this, "bFleeSpeed" )
       .setValue( bFleeSpeed )
       .setLabel("Speed when Fleeing")
       ;
       
    cp5.addSlider("bFleeForce")
       .setColorCaptionLabel(0)
       .setPosition(560,190)
       .setRange(0.1, 3 )
       .plugTo( this, "bFleeForce" )
       .setValue( bFleeForce )
       .setLabel("Reaction Speed when Fleeing")
       ;  

    cp5.addSlider("bTireSpeed")
       .setColorCaptionLabel(0)
       .setPosition(560,210)
       .setRange( 0.01, 0.1 )
       .plugTo( this, "bTireSpeed" )
       .setValue( bTireSpeed )
       .setLabel("Tire Speed")
       ;
       
    cp5.addSlider("bAgeSpeed")
       .setColorCaptionLabel(0)
       .setPosition(560,230)
       .setRange( 0.01, 0.06 )
       .plugTo( this, "bAgeSpeed" )
       .setValue( bAgeSpeed)
       .setLabel("Speed of Ageing")
       ;
       
    cp5.addSlider("bFertilitySpeed")
       .setColorCaptionLabel(0)
       .setPosition(560,250)
       .setRange( 0.01, 0.5 )
       .plugTo( this, "bFertilitySpeed" )
       .setValue( bFertilitySpeed)
       .setLabel("Fertility Cycle Speed")
       ;    
       
    cp5.addSlider("bReplenish")
       .setColorCaptionLabel(0)
       .setPosition(560,270)
       .setRange( 1, 25 )
       .plugTo( this, "bReplenish" )
       .setValue( bReplenish)
       .setLabel("Energy from Feeding")
       ;    

    cp5.addSlider("bCohStrength")
       .setColorCaptionLabel(0)
       .setPosition(560,290)
       .setRange( 0, 10 )
       .plugTo( this, "bCohStrength" )
       .setValue( bCohStrength)
       .setLabel("Cohesion Strength")
       ;    
    cp5.addSlider("bAliStrength")
       .setColorCaptionLabel(0)
       .setPosition(560,310)
       .setRange( 0, 10 )
       .plugTo( this, "bAliStrength" )
       .setValue( bAliStrength)
       .setLabel("Alignment Strength")
       ;    
    cp5.addSlider("bSepStrength")
       .setColorCaptionLabel(0)
       .setPosition(560,330)
       .setRange( 0, 10 )
       .plugTo( this, "bSepStrength" )
       .setValue( bSepStrength)
       .setLabel("Separation Strength")
       ;    
  }
  
} 

class SGeneGui {
  float sTireSpeed, sAgeSpeed, sFertilitySpeed;
  float sReplenish;
  String stitle;  
  SDefault sd;
  
  
  SGeneGui(String _s){
    
    stitle = _s;
    sd = new SDefault();
    
    sTireSpeed = sd.tireSpeed;
    sAgeSpeed = sd.ageSpeed;
    sFertilitySpeed = sd.fertilitySpeed;
    sReplenish = sd.replenish;
    
    cp5.addTextlabel("stitle")
       .setText(stitle + " Parameters")
       .setPosition(560, 350)
       .setColorValue(000)
       .setFont(createFont("Georgia",20))
       ;   

    cp5.addSlider("sTireSpeed")
       .setColorCaptionLabel(0)
       .setPosition(560,380)
       .setRange( 0.01, 0.1 )
       .plugTo( this, "sTireSpeed" )
       .setValue( sTireSpeed )
       .setLabel("Tire Speed")
       ;
       
    cp5.addSlider("sAgeSpeed")
       .setColorCaptionLabel(0)
       .setPosition(560,400)
       .setRange( 0.01, 0.05 )
       .plugTo( this, "sAgeSpeed" )
       .setValue( sAgeSpeed)
       .setLabel("Ageing Speed")
       ;
       
    cp5.addSlider("sFertilitySpeed")
       .setColorCaptionLabel(0)
       .setPosition(560,420)
       .setRange( 0.01, 1 )
       .plugTo( this, "sFertilitySpeed" )
       .setValue( sFertilitySpeed)
       .setLabel("Fertility Cycle Speed")
       ;    
       
    cp5.addSlider("sReplenish")
       .setColorCaptionLabel(0)
       .setPosition(560,440)
       .setRange( 1, 25 )
       .plugTo( this, "sReplenish" )
       .setValue( sReplenish)
       .setLabel("Energy from Feeding")
       ;    
  }
  
}
   
class PGeneGui{
  String pTitle;
  float pAgeSpeed;
  float poisonProb;
  PDefault pd;
      
  PGeneGui(String _s){
    pTitle = _s;
    pd = new PDefault();
    pAgeSpeed = pd.ageSpeed;
    poisonProb = pd.poisonProb;   

    cp5.addTextlabel("pTitle")
       .setText(pTitle + " Parameters")
       .setPosition(560, 460)
       .setColorValue(000)
       .setFont(createFont("Georgia",20))
       ;  
       
    cp5.addSlider("pAgeSpeed")
       .setColorCaptionLabel(0)
       .setPosition(560,490)
       .setRange( 0.01, 0.1 )
       .plugTo( this, "pAgeSpeed" )
       .setValue(pAgeSpeed)
       .setLabel("Ageing Speed")
       ; 
    
    cp5.addSlider("poisonProb")
       .setColorCaptionLabel(0)
       .setPosition(560,510)
       .setRange( 0.01, 0.5 )
       .plugTo( this, "poisonProb" )
       .setValue(poisonProb)
       .setLabel("Poison Probability")
       ;   
      
  }
}
