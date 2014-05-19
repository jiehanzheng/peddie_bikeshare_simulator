import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;

final double PARTICIPATION_RATE = 21d/29;

// Mondays, Fridays
TransitionType[] transitionQueue = { TransitionType.BREAKFAST,
                                     TransitionType.CLASS_PERIOD,
                                     TransitionType.CLASS_PERIOD,
                                     TransitionType.CHAPEL,
                                     TransitionType.CLASS_PERIOD,
                                     TransitionType.LUNCH,
                                     TransitionType.CLASS_PERIOD,
                                     TransitionType.CLASS_PERIOD,
                                     TransitionType.SPORTS,
                                     TransitionType.HOME };

// Tuesdays, Thursdays
//TransitionType[] transitionQueue = { TransitionType.BREAKFAST,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.DMX,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.LUNCH,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.SPORTS,
//                                     TransitionType.HOME };

// Wednesday
//TransitionType[] transitionQueue = { TransitionType.BREAKFAST,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.COMMUNITY_MEETING,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.LUNCH,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.CLASS_PERIOD,
//                                     TransitionType.SPORTS,
//                                     TransitionType.HOME };

int currentTransition = -1;

PImage mapImage;

void setup() {  
  // if the following line is uncommented, all visual components gets disabled
//  runBatchSimulations(10000, "MonFri");
  
  mapImage = loadImage("map.png");
  size(mapImage.width/2, mapImage.height/2, "processing.core.PGraphicsRetina2D");
  hint(ENABLE_RETINA_PIXELS);
  
  populateStudents();
  println("Press J to simulate a transition.");
}

void populateStudents() {
  addStudentsToBuilding(Building.POTTER_SOUTH, 36);
  addStudentsToBuilding(Building.POTTER_NORTH, 31);
  addStudentsToBuilding(Building.KERR_NORTH, 32);
  addStudentsToBuilding(Building.KERR_SOUTH, 32);
  addStudentsToBuilding(Building.AVERY, 26);
  addStudentsToBuilding(Building.COLEMAN, 26);
  addStudentsToBuilding(Building.TRASK, 16);
  addStudentsToBuilding(Building.AC, 28);
  addStudentsToBuilding(Building.MASTERS, 64);
  addStudentsToBuilding(Building.MARIBOE, 22);
  addStudentsToBuilding(Building.CASPERSEN, 21);
  addStudentsToBuilding(Building.ROBERSON, 8);
  addStudentsToBuilding(Building.STUD, 194/3);
  addStudentsToBuilding(Building.SCIENCE, 194/3);
  addStudentsToBuilding(Building.ANNENBERG, 194/3);
}

void transition(TransitionType type) {
  // ask students to move
  for (Student student : Student.students) {
    student.transition(type);
  }
}

void addStudentsToBuilding(Building building, int numStudents) {
  for (int i = 1; i <= numStudents * PARTICIPATION_RATE; i++) {
    Student.students.add(new Student(building));
  }
}

void draw() {
  background(#FFFFFF);
  
  // draw map background
  tint(255, 200);
  image(mapImage, 0, 0, mapImage.width/2, mapImage.height/2);
  tint(255, 255);
    
  // create PGraphics for other objects to draw on
  PGraphics pg = createGraphics(mapImage.width/2, mapImage.height/2);
  pg.beginDraw();
  
  for (Building building : Building.values()) {
    // draw a circle around entrance of each dorm
    pg.stroke(#AAB706, 200);
    pg.fill(#AAB706, 50);
    building.markLocation(pg);
    
//    // draw line to station
//    pg.stroke(#AA6A84);
//    strokeWeight(2);
//    building.drawLineToStation(pg);
//    strokeWeight(1);
    
    // update number of students in each building
    building.setNumOccupants(Student.getNumStudentsInBuilding(building));
    
    // print number of occupants
    pg.fill(#AAB706);
    building.drawNumOccupants(pg);
  }
  
  for (Station station : Station.values()) {
    pg.stroke(#DA4038, 200);
    pg.fill(#DA4038, 50);
    station.markLocation(pg);
    
    pg.fill(#DA4038);
    station.drawNumBikes(pg);
  }
  
  pg.endDraw();
  image(pg, 0, 0);
  
  // indicate transition id
  fill(#000000);
  textSize(30);
  text((currentTransition + 1) + ": " + 
    (currentTransition > -1 ? transitionQueue[currentTransition] : "Initial condition"), 18, 32); 
}

void mouseClicked() {
  println("mouseClicked: " + mouseX + ", " + mouseY);
}

void keyPressed() {
  if (key != 'j')
    return;
  
  if (currentTransition + 1 <= transitionQueue.length - 1)
    currentTransition++;
  
  transition(transitionQueue[currentTransition]);
}

void runBatchSimulations(int numSimulations, String name) {
  // results table
  Table resultsTable = new Table();
  for (Station station : Station.values()) {
    resultsTable.addColumn(station.name() + "_min");
    resultsTable.addColumn(station.name() + "_max");
    resultsTable.addColumn(station.name() + "_last");
  }
  
  // summary table across all simulations
  Table summaryTable = new Table();
  summaryTable.addColumn("Station");
  summaryTable.addColumn("min(min)");
  summaryTable.addColumn("max(max)");
  summaryTable.addColumn("mean(last)");
  summaryTable.addColumn("min(last)");
  summaryTable.addColumn("max(last)");
  
  // create DescriptiveStatistics for each station to keep data and get descriptive stats
  HashMap<Station, DescriptiveStatistics> stationSummaryStatsMin = new HashMap<Station, DescriptiveStatistics>();
  HashMap<Station, DescriptiveStatistics> stationSummaryStatsMax = new HashMap<Station, DescriptiveStatistics>();
  HashMap<Station, DescriptiveStatistics> stationSummaryStatsLast = new HashMap<Station, DescriptiveStatistics>();
  for (Station station : Station.values()) {
    stationSummaryStatsMin.put(station, new DescriptiveStatistics());
    stationSummaryStatsMax.put(station, new DescriptiveStatistics());
    stationSummaryStatsLast.put(station, new DescriptiveStatistics());
  }
    
  // run simulations
  //
  // for each simulation
  for (int i = 1; i <= numSimulations; i++) {
    // reset vars
    Student.students = new ArrayList<Student>();
    for (Station station : Station.values()) { station.resetNumBikes(); }
    for (Building building : Building.values()) { building.resetNumOccupants(); }
    populateStudents();
    
    // create DescriptiveStatistics for each station to keep data and get descriptive stats
    HashMap<Station, DescriptiveStatistics> stationStats = new HashMap<Station, DescriptiveStatistics>();
    for (Station station : Station.values()) {
      stationStats.put(station, new DescriptiveStatistics());
    }
    
    // record number of bikes at each station, in the morning
    for (Station station : Station.values()) {
      stationStats.get(station).addValue(station.getNumBikes());
    }
    
    // for each transition in queue
    for (int transitionId = 0; transitionId < transitionQueue.length; transitionId++) {
      // do the transition
      transition(transitionQueue[transitionId]);
      
      // record number of bikes at each station, after each transition
      for (Station station : Station.values()) {
        stationStats.get(station).addValue(station.getNumBikes());
      }
    }
    
    TableRow simulationRow = resultsTable.addRow();
    for (Station station : Station.values()) {
      // stats for each station at the end of each simulation
      int numBikeMin  = (int) stationStats.get(station).getMin();
      int numBikeMax  = (int) stationStats.get(station).getMax();
      int numBikeLast = (int) station.getNumBikes();
      
      // write into results table
      simulationRow.setInt(station.name() + "_min", numBikeMin);
      simulationRow.setInt(station.name() + "_max", numBikeMax);
      simulationRow.setInt(station.name() + "_last", numBikeLast);
      
      // prepare data for summary table
      stationSummaryStatsMin.get(station).addValue(numBikeMin);
      stationSummaryStatsMax.get(station).addValue(numBikeMax);
      stationSummaryStatsLast.get(station).addValue(numBikeLast);
    }
  }
  
  // write details csv
  saveTable(resultsTable, "data/" + name + "_x" + numSimulations + "_details" + ".csv");
  
  // write summary csv
  for (Station station : Station.values()) {
    TableRow stationRow = summaryTable.addRow();
    stationRow.setString("Station", station.name());
    stationRow.setInt("min(min)", (int) stationSummaryStatsMin.get(station).getMin());
    stationRow.setInt("max(max)", (int) stationSummaryStatsMax.get(station).getMax());
    stationRow.setInt("mean(last)", (int) stationSummaryStatsLast.get(station).getMean());
    stationRow.setInt("min(last)", (int) stationSummaryStatsLast.get(station).getMin());
    stationRow.setInt("max(last)", (int) stationSummaryStatsLast.get(station).getMax());
  }
  saveTable(summaryTable, "data/" + name + "_x" + numSimulations + "_summary" + ".csv");
  
  println("Finished running " + numSimulations + " simulations for " + name + ".");
  exit();
}

