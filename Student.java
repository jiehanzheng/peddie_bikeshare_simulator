import java.util.List;
import java.util.ArrayList;

class Student {
  
  /**
   * Distance longer than which a student would ride a bike
   *
   * In pixels...we will convert to meters, etc.
   */
  private static final int BIKE_THRESHOLD = 200;
  
  public static ArrayList<Student> students = new ArrayList<Student>();
  
  private final Building home;
  private Building currentBuilding;
  
  public Student(Building home) {
    this.home = home;
    this.currentBuilding = home;
  }
  
  public static int getNumStudentsInBuilding(Building building) {
    int count = 0;
    for (Student student : students) {
      if (student.getCurrentBuilding() == building)
        count++;
    }
    return count;
  }
  
  public Building getCurrentBuilding() { return currentBuilding; }
  
  public void transition(TransitionType type) {
    Building destBuilding = null;
    
    ArrayList<BuildingProbability> buildingProbabilities;
    switch (type) {
      case BREAKFAST:
        buildingProbabilities = new ArrayList<BuildingProbability>();
        buildingProbabilities.add(new BuildingProbability(Building.STUD, 0.451));
        buildingProbabilities.add(new BuildingProbability(currentBuilding, 0.549));
        destBuilding = BuildingProbability.pickOne(buildingProbabilities);
        break;
      case CLASS_PERIOD:
        buildingProbabilities = new ArrayList<BuildingProbability>();
        buildingProbabilities.add(new BuildingProbability(Building.ANNENBERG, 0.4));
        buildingProbabilities.add(new BuildingProbability(Building.HISTORY, 0.2));
        buildingProbabilities.add(new BuildingProbability(Building.SCIENCE, 0.2));
        buildingProbabilities.add(new BuildingProbability(Building.SWIG, 0.1));
        buildingProbabilities.add(new BuildingProbability(home, 0.1));
        destBuilding = BuildingProbability.pickOne(buildingProbabilities);
        break;
      case DMX:
        buildingProbabilities = new ArrayList<BuildingProbability>();
        buildingProbabilities.add(new BuildingProbability(home, 0.55));
        buildingProbabilities.add(new BuildingProbability(Building.ANNENBERG, 0.1));
        buildingProbabilities.add(new BuildingProbability(Building.HISTORY, 0.1));
        buildingProbabilities.add(new BuildingProbability(Building.SCIENCE, 0.1));
        buildingProbabilities.add(new BuildingProbability(Building.STUD, 0.1));
        buildingProbabilities.add(new BuildingProbability(Building.SWIG, 0.05));
        destBuilding = BuildingProbability.pickOne(buildingProbabilities);
        break;
      case COMMUNITY_MEETING:
        destBuilding = Building.THEATER;
        break;
      case CHAPEL:
        destBuilding = Building.CHAPEL;
        break;
      case LUNCH:
        buildingProbabilities = new ArrayList<BuildingProbability>();
        buildingProbabilities.add(new BuildingProbability(home, 0.1));
        buildingProbabilities.add(new BuildingProbability(Building.STUD, 0.8));
        buildingProbabilities.add(new BuildingProbability(Building.OFF_CAMPUS, 0.1));
        destBuilding = BuildingProbability.pickOne(buildingProbabilities);
        break;
      case SPORTS:
        buildingProbabilities = new ArrayList<BuildingProbability>();
        buildingProbabilities.add(new BuildingProbability(Building.ATHLETIC, 0.638));
        buildingProbabilities.add(new BuildingProbability(Building.THEATER, 0.045));
        buildingProbabilities.add(new BuildingProbability(Building.STUD, 0.047));
        buildingProbabilities.add(new BuildingProbability(Building.ANNENBERG, 0.125));
        buildingProbabilities.add(new BuildingProbability(Building.OFF_CAMPUS, 0.075));
        buildingProbabilities.add(new BuildingProbability(home, 0.07));
        destBuilding = BuildingProbability.pickOne(buildingProbabilities);
        break;
      case HOME:
        destBuilding = home;
        break;
    }
    
    if (destBuilding == null)
      throw new RuntimeException("Probabilities for this transition situation have not been defined: " + 
        type + " @ " + currentBuilding);
    
    // get closest station from this building
    Station srcStation = currentBuilding.getClosestStation();
    Station destStation = destBuilding.getClosestStation();
    
//    System.out.print("Student moved from " + currentBuilding);
    
    // determine if the student would bike
    if (currentBuilding.distanceTo(destBuilding) > BIKE_THRESHOLD) {
       // move a bike
       srcStation.takeBike();
       destStation.returnBike();
//       System.out.print(", on a bike from " + srcStation + "->" + destStation + ",");
    }
    
    // move student
//    System.out.println(" to " + destBuilding);
    currentBuilding = destBuilding;
  }
}
