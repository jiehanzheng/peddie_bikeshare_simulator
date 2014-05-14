TransitionType[] transitionQueue = { TransitionType.CLASS_PERIOD, 
                                     TransitionType.CLASS_PERIOD,
                                     TransitionType.DMX,
                                     TransitionType.CLASS_PERIOD,
                                     TransitionType.LUNCH,
                                     TransitionType.CLASS_PERIOD,
                                     TransitionType.CLASS_PERIOD,
                                     TransitionType.SPORTS,
                                     TransitionType.HOME };
int currentTransition = -1;

PImage mapImage;
ArrayList<Student> students;

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
}

void transition(TransitionType type) {
  // ask students to move
  for (Student student : Student.students) {
    student.transition(type);
  }
}

void addStudentsToBuilding(Building building, int numStudents) {
  for (int i = 1; i <= numStudents; i++) {
    Student.students.add(new Student(building));
  }
}

void setup() {
  mapImage = loadImage("map.png");
  size(mapImage.width/2, mapImage.height/2, "processing.core.PGraphicsRetina2D");
  hint(ENABLE_RETINA_PIXELS);
  
  populateStudents();
  
  println("Press J to simulate a transition.");
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
