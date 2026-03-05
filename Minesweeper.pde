/*  ideas
hi
Done:
add the highlights and shadows on each button to make it look more 3D
add the actual mine images instead of just red boxes
add a flag image instead of just black boxes
add  the smily face in the middle for if you win or lose
add it so you cant click on flags
add a timer
add chording
add a counter for how many mines are left
add it so you cant add a flag to a clicked button
add when you are dead you stop being able to click on the buttons
add a reset button which is the smily face if you click it
add different difficulty levels


*/
PImage img;
PImage flag;

int NUM_ROWS = 16; 
int NUM_COLS = 16;
int NUM_MINES =40;
int flagsPlaced = 0;
int startTime;
int elapsedTime;
boolean timerStarted = false;
MSButton firstMine = null;
boolean firstClick = true;

private MSButton[][] buttons; 
private ArrayList<MSButton> mines; 
private boolean gameLost = false;

void setup ()
{
    img = loadImage("bomb.png");
    flag = loadImage("flaggy.png");
    size(600, 780);
    textSize(32);
    textAlign(CENTER,CENTER);
    background(192,192,192);
    noStroke();
    fill(255,255,255);
    rect(0,0,600,10);
    rect(0,0,10,780);
    fill(128,128,128);
    rect(10,770,600,10);
    triangle(0,780,10,770,10,780);
    rect(590,10,10,780);
    triangle(600,0,590,10,600,10);
    fill(128,128,128);
    rect(40,220,10,510);
    rect(40,220,510,10);
    fill(255,255,255);
    rect(40,730,510,10);
    rect(550,220,10,520);
    fill(128,128,128);
    triangle(550,220,560,220,550,230);
    triangle(50,730,40,740,40,730);
   //upper part 
    rect(40,40,520,8);
    rect(40,40,8,150);
    fill(255,255,255);
    rect(552,40,8,150);
    rect(40,182,520,8);
    fill(128,128,128);
    triangle(552,40,560,40,552,48);
    triangle(40,182,40,190,48,182);

    //smily face border
    fill(255,255,255);
    rect(250,65,100,10);
    rect(250,65,10,100);
    fill(128,128,128);
    rect(340,65,10,100);
    rect(250,155,100,10);
    fill(255,255,255);
    triangle(340,65,350,65,340,75);
    triangle(250,155,250,165,260,155);


    mines = new ArrayList<MSButton>();   
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r, c);
        }
    }
}
public void setMines(int firstRow, int firstCol)
{
    mines.clear();
    
    int row=(int)(Math.random()*NUM_ROWS);
    int col=(int)(Math.random()*NUM_COLS);
    for(int i=0; i<NUM_MINES; i++){
        while(mines.contains(buttons[row][col]) || (row == firstRow && col == firstCol) || (row == firstRow-1 && col == firstCol) || (row == firstRow+1 && col == firstCol) || (row == firstRow && col == firstCol-1) || (row == firstRow && col == firstCol+1) || (row == firstRow-1 && col == firstCol-1) || (row == firstRow-1 && col == firstCol+1) || (row == firstRow+1 && col == firstCol-1) || (row == firstRow+1 && col == firstCol+1) ){
            row=(int)(Math.random()*NUM_ROWS);
            col=(int)(Math.random()*NUM_COLS);
        }
        mines.add(buttons[row][col]);
    }
}
public void setDifficulty(int rows, int cols, int minesCount)
{
    mines.clear();
    NUM_ROWS = rows;
    NUM_COLS = cols;
    NUM_MINES = minesCount;
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r, c);
        }
    }
    resetGame();
}
public void resetGame()
{
    mines.clear();
    gameLost = false;
    firstClick = true;
    firstMine = null;
    timerStarted = false;
    elapsedTime = 0;
    flagsPlaced = 0;

    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].clicked = false;
            buttons[r][c].flagged = false;
            buttons[r][c].setLabel("");
        }
    }
}
public void keyPressed()
{
    if (key == 'b' || key == 'B') {
        setDifficulty(9, 9, 10);
    }
    else if (key == 'i' || key == 'I') {
        setDifficulty(16, 16, 40);
    }
    else if (key == 'e' || key == 'E') {
        setDifficulty(21, 21, 70);
    }
}
public void draw ()
{
    //smily face nuetral
    if(gameLost == false && isWon() == false){
        fill(255,255,0);
        ellipse(300,115,80,80);
        fill(0);
        ellipse(280,100,10,10);
        ellipse(320,100,10,10);
        arc(300,120,50,30,0,PI);
    }

    if(isWon() == true && gameLost == false){
        displayWinningMessage();
        //smily face with glasses for win
        fill(255,255,0);
        ellipse(300,115,80,80);
        fill(0);
        arc(280,100,20,30,0,PI);
        arc(320,100,20,30,0,PI);

        rect(285,100,30,3);
        stroke(0);
        strokeWeight(3);
        line(270,103,260,110);
        line(330,103,340,110);
        noStroke();
        
    
        arc(300,120,50,30,0,PI);
    }
    else if(gameLost == true){
        displayLosingMessage();
        //sad face
        fill(255,255,0);
        ellipse(300,115,80,80);
        fill(0);
        textSize(20);
        text("X",280,100);
        text("X",320,100);
        textSize(32);
        arc(300,130,50,30,PI,2*PI);
    }
    fill(192,192,192);
    rect(50,50,100,100);
    rect(450,50,100,100);
    fill(0);
    textSize(40);
    text(NUM_MINES - flagsPlaced, 100, 115);
    if(timerStarted && !gameLost && !isWon()){
        elapsedTime = (int)((millis() - startTime) / 1000);
    }
    text(elapsedTime, 500, 115);
    textSize(32);
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].draw();
        }
    }
}
public boolean isWon() 
{
    for(int r=0; r<NUM_ROWS; r++){
        for(int c=0; c<NUM_COLS; c++){
            if(!buttons[r][c].clicked && !mines.contains(buttons[r][c]) )
                return false;
        }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int r=0; r<NUM_ROWS; r++){
        for(int c=0; c<NUM_COLS; c++){
            if(mines.contains(buttons[r][c]))
                buttons[r][c].clicked = true;
        }
    } 
}
public void displayWinningMessage()
{
    for(int r=0; r<NUM_ROWS; r++){
        for(int c=0; c<NUM_COLS; c++){
            if(mines.contains(buttons[r][c]))
                buttons[r][c].flagged = true;
        }
    }
    for(int r=0; r<NUM_ROWS; r++){
        for(int c=0; c<NUM_COLS; c++){
            if(!mines.contains(buttons[r][c]) && !buttons[r][c].clicked)
                buttons[r][c].mousePressed();
        }
    }
}
public boolean isValid(int r, int c)
{
    return(0<=r && r<NUM_ROWS && 0<=c && c<NUM_COLS);
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r=row-1; r<=row+1; r++){
        for(int c=col-1; c<=col+1; c++){
            if(isValid(r,c) && mines.contains(buttons[r][c]))
                numMines++;
        }
    }
    return numMines;
}
public void mousePressed()
{
    float dx = mouseX - 300;
    float dy = mouseY - 115;
    float distance = sqrt(dx*dx + dy*dy);

    if (distance <= 40) {
        resetGame();
    }
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (buttons[r][c].contains(mouseX, mouseY)) {
                buttons[r][c].mousePressed();
                return;
            }
        }
    }
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = (float)500/NUM_COLS;
        height = (float)500/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width+50;
        y = myRow*height+230;
        myLabel = "";
        flagged = clicked = false;
    }
    public boolean contains(float mx, float my)
    {
        return mx >= x && mx < x + width && my >= y && my < y + height;
    }
    public void mousePressed() 
    {
        if (gameLost || isWon())
            return;
        if (mouseButton == RIGHT){
            if (!clicked) {
                flagged = !flagged;
                if (flagged)
                    flagsPlaced++;
                else
                    flagsPlaced--;
            }
            return;
        }
        if (flagged)
            return;
        if (clicked && myLabel.length() > 0){
            if (countFlaggedNeighbors() == countMines(myRow, myCol)){
                for (int r = myRow - 1; r <= myRow + 1; r++) {
                    for (int c = myCol - 1; c <= myCol + 1; c++) {
                        if (isValid(r, c)) {
                            if (!buttons[r][c].clicked && !buttons[r][c].flagged) {
                                buttons[r][c].mousePressed();
                            }
                        }
                    }
                }
            }
            return;
        }

        if (firstClick) {
            firstClick = false;
            setMines(myRow, myCol);
            startTime = millis();
            timerStarted = true;
        }
        clicked = true;
        if (mines.contains(this)) {
            gameLost = true;
            firstMine = this;
            return;
        }
        int mineCount = countMines(myRow, myCol);

        if (mineCount > 0) {
            setLabel(mineCount);
        } 
        else {
            for (int r = myRow - 1; r <= myRow + 1; r++) {
                for (int c = myCol - 1; c <= myCol + 1; c++) {
                    if (isValid(r, c) && !buttons[r][c].clicked) {
                        buttons[r][c].mousePressed();
                    }
                }
            }
        }
    }

    public void mouseEvent(processing.event.MouseEvent m)
    {
        if (m.getAction() == processing.event.MouseEvent.PRESS)
        {
            float mx = m.getX();
            float my = m.getY();
            if (mx >= x && mx < x + width && my >= y && my < y + height)
            {
                mousePressed();
            }
        }
    }
    public void draw ()
    {    
    float rx = round(x);
    float ry = round(y);
    float rw = round(width);
    float rh = round(height);

    if (flagged){
        fill(192,192,192);
        rect(rx, ry, rw, rh);
        fill(255,255,255);
        rect(rx, ry, rw-rh/7, rh/7);
        rect(rx, ry, rw/7, rh-rh/7);
        fill(128,128,128);
        rect(rx, ry+rh-rh/7, rw, rh/7);
        rect(rx+rw-rw/7, ry, rw/7, rh);
        fill(255,255,255);
        triangle(rx+rw, ry, rx+rw-rw/7-1, ry, rx+rw-rw/7, ry+rh/7);
        triangle(rx, ry+rh, rx, ry+rh-rh/7-1, rx+rw/7, ry+rh-rh/7);
        imageMode(CENTER);
        image(flag, rx+rw/2, ry+(rh/2)*1.1, rw*0.6, rh*0.6);
        imageMode(CORNER);
    }
    else if( clicked && mines.contains(this) ){
        fill(192,192,192);
        stroke(128,128,128);
        strokeWeight(1);
        rect(rx, ry, rw, rh);
        noStroke();
        strokeWeight(3);
        if(this == firstMine){
            fill(255,0,0);
            rect(rx,ry,rw,rh);
        }
        image(img, rx, ry, rw, rh);
        
    }
    else if(clicked){
        fill(192,192,192);
        stroke(128,128,128);
        strokeWeight(1);
        rect(rx, ry, rw, rh);
        noStroke();
    }
    else{
        fill(192,192,192);
        rect(rx, ry, rw, rh);
        fill(255,255,255);
        rect(rx, ry, rw-rh/7, rh/7);
        rect(rx, ry, rw/7, rh-rh/7);
        fill(128,128,128);
        rect(rx, ry+rh-rh/7, rw, rh/7);
        rect(rx+rw-rw/7, ry, rw/7, rh);
        fill(255,255,255);
        triangle(rx+rw, ry, rx+rw-rw/7-1, ry, rx+rw-rw/7, ry+rh/7);
        triangle(rx, ry+rh, rx, ry+rh-rh/7-1, rx+rw/7, ry+rh-rh/7);
    }
    fill(0);
    text(myLabel,rx+rw/2,ry+rh/2);
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
    public int countFlaggedNeighbors()
    {
        int count = 0;
        for (int r = myRow - 1; r <= myRow + 1; r++) {
            for (int c = myCol - 1; c <= myCol + 1; c++) {
                if (isValid(r, c) && buttons[r][c].flagged) {
                    count++;
                }
            }
        }
        return count;
    }
}
