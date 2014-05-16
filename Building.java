import processing.core.*;

enum Building implements Locatable {
//DORM          X    Y    STATION
//----          -    -    -------
  POTTER_SOUTH (195, 86,  Station.POTTER_KERR),
  POTTER_NORTH (232, 75,  Station.POTTER_KERR),
  KERR_NORTH   (234, 127, Station.POTTER_KERR),
  KERR_SOUTH   (229, 148, Station.POTTER_KERR),
  AVERY        (223, 255, Station.AVERY),
  COLEMAN      (288, 264, Station.COLEMAN),
  TRASK        (288, 301, Station.COLEMAN),
  SWIG         (320, 202, Station.COLEMAN),
  SCIENCE      (331, 338, Station.STUD),
  STUD         (329, 279, Station.STUD),
  AC           (214, 321, Station.AC_MASTERS),
  MASTERS      (204, 369, Station.AC_MASTERS),
  MARIBOE      (165, 486, Station.CHAPEL),
  ROBERSON     (258, 540, Station.CHAPEL),
  CHAPEL       (206, 476, Station.CHAPEL),
  CASPERSEN    (245, 504, Station.ANNENBERG),
  ANNENBERG    (306, 458, Station.ANNENBERG),
  HISTORY      (324, 506, Station.ANNENBERG),
  ATHLETIC     (664, 546, Station.ATHLETIC),
  THEATER      (343, 89,  Station.THEATER),
  OFF_CAMPUS   (781, 70,  Station.OFF_CAMPUS);
  
  private int locationX;
  private int locationY;
  private Station station;
  private int numOccupants;
  
  private Building(int locationX, int locationY, Station station) {
    this.locationX = locationX;
    this.locationY = locationY;
    this.station   = station;
  }
  
  public int getX() { return locationX; }
  public int getY() { return locationY; }
  public Station getClosestStation() { return station; }
  
  public void setNumOccupants(int num) { numOccupants = num; }
  public void resetNumOccupants() { setNumOccupants(0); } 
  
  public void markLocation(PGraphics pg) {
    pg.ellipse(locationX, locationY, 10, 10);
  }
  
  public void drawNumOccupants(PGraphics pg) {
    pg.text(numOccupants, locationX + 6, locationY + 12);
  }
  
  public void drawLineToStation(PGraphics pg) {
    pg.line(locationX, locationY, station.getX(), station.getY());
  }
  
  public double distanceTo(Locatable another) {
    return Math.sqrt(Math.pow(getX() - another.getX(), 2) + Math.pow(getY() - another.getY(), 2));
  }
  
}

