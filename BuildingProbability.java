import java.util.List;
import java.util.ArrayList;

class BuildingProbability {
  
  private Building building;
  private double probability;
  
  public BuildingProbability(Building building, double probability) {
    this.building = building;
    this.probability = probability;
  }
  
  public Building getBuilding() { return building; }
  public double getProbability() { return probability; }
  
  public static Building pickOne(List<BuildingProbability> buildingProbabilities) {
    // define ranges
    double cursor = 0;
    List<Partition<Building>> partitions = new ArrayList<Partition<Building>>();
    for (BuildingProbability bp : buildingProbabilities) {
      partitions.add(new Partition<Building>(cursor, cursor + bp.probability, bp.building));
      cursor += bp.probability;
    }
    
    if (Math.abs(cursor - 1d) > 0.000000000000001)
      throw new RuntimeException("Probabilities do not sum up to 1: " + partitions);
      
    // draw a random number
    double num = Math.random();
    
    // see where it falls
    for (Partition<Building> partition : partitions) {
      if (partition.rangeContains(num)) {
        return partition.getOutcome();
      }
    }
    
    throw new RuntimeException("BuildingProbability.pickOne() is unable to pick a building.");
  }
  
  
  static class Partition<T> {
    private double start;
    private double end;
    private T outcome;
    
    public Partition(double start, double end, T outcome) {
      this.start = start;
      this.end = end;
      this.outcome = outcome;
    }
    
    public T getOutcome() { return outcome; }
    public boolean rangeContains(double num) { return start <= num && num <= end; }
    
    public String toString() { return start + "-" + end + " -> " + outcome; }
  }
  
}

