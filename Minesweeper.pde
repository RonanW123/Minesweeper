import de.bezier.guido.*;
private final static int NUM_ROWS = 20, NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines //ArrayList of just the minesweeper buttons that are mined
  = new ArrayList <MSButton>();
private int a = 0;
private boolean end = false;
public void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++)
    for (int j = 0; j < NUM_COLS; j++)
      buttons[i][j] = new MSButton(i, j);

  for (int a = 0; a < 100; a++)
    setMines();
}
public void setMines()
{
  int randomNum1 = (int)(Math.random()*20), randomNum2 = (int)(Math.random()*20);
  if (!mines.contains(buttons[randomNum1][randomNum2]))
    mines.add(buttons[randomNum1][randomNum2]);
}

public void draw ()
{
  background( 0 );
  if (isWon() == true){
    displayWinningMessage();
    end = true;
  }
}

public boolean isWon()
{
  int totalButtons = 0;
  int buttonsClicked = 0;
  for (int i = 0; i < NUM_ROWS; i++)
    for (int j = 0; j < NUM_COLS; j++)  
      if (buttons[i][j].clicked == true)
        buttonsClicked++;

  for (int a = 0; a < buttons.length; a++)
    totalButtons += buttons[a].length;

  if (buttonsClicked == totalButtons)
    return true;
  return false;
}
public void displayLosingMessage()
{
  buttons[NUM_ROWS/2-1][NUM_COLS/2-1].setLabel("L");
  for (int i = 0; i < mines.size(); i++)
    if (mines.get(i).clicked == false)
      mines.get(i).mousePressed();
}
public void displayWinningMessage()
{
  buttons[NUM_ROWS/2-1][NUM_COLS/2-1].setLabel("W");
}
public boolean isValid(int r, int c)
{
  if (r < 20 && c < 20 && r >= 0 && c >= 0)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = row-1; i <= row+1; i++)
    for (int j = col-1; j <= col+1; j++)
      if (isValid(i, j) && mines.contains(buttons[i][j]))
        numMines++;
  if (mines.contains(buttons[row][col]))
    numMines--;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = false;
    clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    a++;
    if(end == false){
      if(mouseButton == LEFT){
      clicked = true;
        if (a == 1 && buttons[myRow][myCol].clicked == true) {
          for (int i = myRow-2; i <= myRow+2; i++){
            for (int j = myCol-2; j <= myCol+2; j++){
              if (isValid(i, j) && mines.contains(buttons[i][j])) {
                mines.remove(buttons[i][j]);
              }
            }
          }
        }
      } if (mouseButton == RIGHT) {
        a--;
        if (flagged == false)
          flagged = true;
        else
          flagged = false;
      } else if (mines.contains(this)) {
        displayLosingMessage();
        end = true;
      } else if(countMines(myRow, myCol) > 0){
        setLabel(countMines(myRow, myCol));
      } else {
        for (int i = myRow-1; i <= myRow+1; i++)
          for (int j = myCol-1; j <= myCol+1; j++)
            if (isValid(i, j) && buttons[i][j].clicked == false)
              buttons[i][j].mousePressed();
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
