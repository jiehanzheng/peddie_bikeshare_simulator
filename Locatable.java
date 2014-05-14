public interface Locatable {
  
  int getX();
  int getY();
  double distanceTo(Locatable another);

//  void markLocation(PGraphics pg);

//  default double distanceTo(Locatable another) {
//    return Math.sqrt(Math.pow(getX() - another.getX(), 2) + Math.pow(getY() - another.getY(), 2));
//  }
  
}

