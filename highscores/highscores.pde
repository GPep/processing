PFont f;
int score = 300000;
int level = 40;
HighScore highScore;
 
void setup() {
  size(800,800);
  f = createFont("Arial",16,true);
  highScore = new HighScore(score, level);
}
 
void draw() {
  background(255);
  highScore.display();
}
 
void keyPressed() {
if (highScore.topTen) {
  if (key == '\n') {
    highScore.saveData();
    highScore.typing = "";
  } 
  else if (key == CODED || key == CONTROL) {
    //ignore it.
  }
  else if (key == BACKSPACE)
  {
    if (highScore.typing.length()>0)
      highScore.typing = highScore.typing.substring(0, highScore.typing.length()-1);
  } 
    else {
    highScore.typing = highScore.typing + key;
  }
}
}
 
class HighScore {
  Table highScores;
  String typing;
  float rowSpace;
  int score;
  int level;
  boolean topTen; //check if score made it into top ten
  boolean scoreEntered; //check if score has been entered and saved
 
  HighScore(int score_, int level_) {
    typing = "";
    score = score_;
    level = level_;
    highScores = loadTable("highScores.csv","header");
    highScores.setColumnType("level", Table.INT); //set column type to INT
    highScores.setColumnType("score", Table.INT); //set column type to INT
    scoreEntered = false;
  }
 
  void display() {
    int indent = 25;
    textFont(f);
    fill(0);
    rowSpace = 40;
    highScores.sort("name"); // in case we have scores that are the same
    highScores.sortReverse("score");
    textAlign(CENTER);
    text("High Scores",width/2,20);
    for (int i = 0; i < highScores.getRowCount(); i++){
      TableRow row = highScores.getRow(i);
      text((i+1) + " - " + row.getString("name") + " Level: " + row.getInt("level") + " Score: " + row.getInt("score"), width/2, rowSpace);
      rowSpace += 20;
      if (row.getInt("score") < score || highScores.lastRowIndex() < 9) { //check if score is in top ten
       topTen = true;
      } else {
       topTen = false; //Score has not made the top 10
      }
    }
    if (!scoreEntered) {
      if (topTen) { 
        textAlign(RIGHT);
        text("Please enter your name:  " + typing,width/2,rowSpace+10);
      } else {
        textAlign(CENTER);
        text("You did not make the High Score list this time, why don't you try again?",width/2,rowSpace+10);
      }
    }
    println(topTen);
  }
  void saveData() {
    if (highScores.lastRowIndex() < 9) { // if there are less than ten scores in top ten
    TableRow newRow = highScores.addRow();
    newRow.setInt("id", highScores.lastRowIndex());
    newRow.setString("name", typing);
    newRow.setInt("level", level);
    newRow.setInt("score", score);
    saveTable(highScores, "data/highScores.csv");
    } else {
    highScores.removeRow(9); //remove number 10 and replace with new top 10 score
    TableRow newRow = highScores.addRow();
    newRow.setInt("id", highScores.lastRowIndex());
    newRow.setString("name", typing);
    newRow.setInt("level", level);
    newRow.setInt("score", score);
    saveTable(highScores, "data/highScores.csv");
    }
    scoreEntered = true;  
 
  }
 
}
