import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 16;
public final static int NUM_COLS = 16;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int row = 0; row < NUM_ROWS; row++)
        for(int col = 0; col < NUM_COLS; col++)
            buttons[row][col] = new MSButton(row, col);
    for(int i = 0; i < 10; i++)
        setMines();
}
public void setMines()
{
    //your code
    int randomRow = (int)(Math.random()*NUM_ROWS);
    int randomCol = (int)(Math.random()*NUM_COLS);
    if(mines.contains(buttons[randomRow][randomCol]) == false)
        mines.add(buttons[randomRow][randomCol]);
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
    {
        displayWinningMessage();
        noLoop();
    }
    else if(isLost() == true)
    {
        displayLosingMessage();
        noLoop();
    }
}
public boolean isWon()
{
    //your code here
    for(int i = 0; i < mines.size(); i++)
        if(!mines.get(i).isFlagged())
            return false;
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
            if(!mines.contains(buttons[r][c]))
                if(!buttons[r][c].isClicked())
                    return false;
    return true;
}
public boolean isLost()
{
    for(int i = 0; i < mines.size(); i++)
        if(mines.get(i).isClicked() && !mines.get(i).isFlagged())
            return true;
    return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int i = 0; i < mines.size(); i++)
        mines.get(i).mousePressed();
    fill(255);
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
        {
            buttons[r][c].setLabel("");
            buttons[r][c].setColr(255,255 , 255);
        }
    buttons[4][1].setLabel("H");
    buttons[4][2].setLabel("A");
    buttons[4][3].setLabel("H");
    buttons[4][4].setLabel("A");
    buttons[4][6].setLabel("O");
    buttons[4][7].setLabel("O");
    buttons[4][8].setLabel("F");
}
public void displayWinningMessage()
{
    //your code here
    for(int r = 0; r < NUM_ROWS; r++)
        for(int c = 0; c < NUM_COLS; c++)
        {
            buttons[r][c].setLabel("");
            buttons[r][c].setColr(255, 255, 255);
        }
 
    buttons[6][1].setLabel("G");
    buttons[6][2].setLabel("O");
    buttons[6][4].setLabel("U");
    buttons[6][5].setLabel("K");
    buttons[6][6].setLabel("R");
    buttons[6][7].setLabel("A");
    buttons[6][8].setLabel("I");
    buttons[6][9].setLabel("N");
    buttons[6][10].setLabel("E");
    
}

public class MSButton
{
    private int r, c, colr;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        colr = color(0, 0, 0);
        x = c*width;
        y = r*height;
        label = "";
        flagged= clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed() 
    {
        clicked = true;
        //your code here
        if(mouseButton == RIGHT)
        {
            if(flagged == false)
                flagged = true;
            else
            {
                clicked = false;
                flagged = false;
            }
        }
        else if(!mines.contains(buttons[r][c]) && countMines(r, c) > 0)
        {
            setLabel(""+countMines(r, c));
        }
        else
        {
            if(isValid(r-1, c) && !buttons[r-1][c].isClicked())
                buttons[r-1][c].mousePressed();
            if(isValid(r, c-1) && !buttons[r][c-1].isClicked())
                buttons[r][c-1].mousePressed();
            if(isValid(r, c+1) && !buttons[r][c+1].isClicked())
                buttons[r][c+1].mousePressed();
            if(isValid(r+1, c) && !buttons[r+1][c].isClicked())
                buttons[r+1][c].mousePressed();
        }
    }

    public void draw()
    {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
            fill(255,255,0);
        else if(clicked)
            fill( 0,0,255 );
        else 
            fill( 100 );
        rect(x, y, width, height);
        fill(colr);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public void setColr(int x, int y, int z)
    {
        colr = color(x, y, z);
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
            return true;
        else
            return false;
    }
    public int countMines(int row, int col)
    {
        int numMines = 0;
        if(isValid(row-1, col-1))
        {
            if(mines.contains(buttons[row-1][col-1]))
                numMines++;
        }
        if(isValid(row-1, col))
        {
            if(mines.contains(buttons[row-1][col]))
                numMines++;
        }
        if(isValid(row-1, col+1))
        {
            if(mines.contains(buttons[row-1][col+1]))
                numMines++;
        }
        if(isValid(row, col-1))
        {
            if(mines.contains(buttons[row][col-1]))
                numMines++;
        }
        if(isValid(row, col+1))
        {
            if(mines.contains(buttons[row][col+1]))
                numMines++;
        }
        if(isValid(row+1, col-1))
        {
            if(mines.contains(buttons[row+1][col-1]))
                numMines++;
        }
        if(isValid(row+1, col))
        {
            if(mines.contains(buttons[row+1][col]))
                numMines++;
        }
        if(isValid(row+1, col+1))
        {
            if(mines.contains(buttons[row+1][col+1]))
                numMines++;
        }
        return numMines;
    }
}
