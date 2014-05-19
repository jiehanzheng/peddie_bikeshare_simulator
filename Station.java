import processing.core.*;

enum Station implements Locatable {
//STATION       X    Y    #BIKES
//-------       -    -    ------
  POTTER_KERR  (243, 105, 0),
  AVERY        (225, 265, 0),
  COLEMAN      (288, 264, 0),
  AC_MASTERS   (209, 337, 0),
  CHAPEL       (192, 472, 0),
  ANNENBERG    (281, 454, 0),
  STUD         (334, 315, 0),
  ATHLETIC     (646, 551, 0),
  THEATER      (346, 111, 0),
  OFF_CAMPUS   (781, 70,  0);
  
  private int locationX;
  private int locationY;
  private final int initialNumBikes;
  private int numBikes;
  
  private Station(int locationX, int locationY, int numBikes) {
    this.locationX = locationX;
    this.locationY = locationY;
    this.initialNumBikes = numBikes;
    this.numBikes  = numBikes;
  }
  
  public int getX() { return locationX; }
  public int getY() { return locationY; }
  
  public void markLocation(PGraphics pg) {
    pg.ellipse(locationX, locationY, 30, 30);
  }
  
  public void drawNumBikes(PGraphics pg) {
    pg.text(numBikes, locationX + 14, locationY - 8);
  }
  
  public int getNumBikes() { return numBikes; }
  
  public void takeBike() { numBikes--; }
  public void returnBike() { numBikes++; }
  
  public void resetNumBikes() { numBikes = initialNumBikes; }
  
  public double distanceTo(Locatable another) {
    return Math.sqrt(Math.pow(getX() - another.getX(), 2) + Math.pow(getY() - another.getY(), 2));
  }
  
}

