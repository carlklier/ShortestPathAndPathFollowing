import java.util.List;
class City{
  String name;
  int drawx;
  int drawy;
  List<Road> incoming;
  List<Road> outgoing;
  
  City(String name, int drawx, int drawy){
    this.name = name;
    this.drawx = drawx;
    this.drawy = drawy;
    this.incoming = new ArrayList<Road>();
    this.outgoing = new ArrayList<Road>();
   }
   
  void edgeTo(City city, float distance) {
    Road road = new Road(this, city, distance);
    this.outgoing.add(road);
    city.incoming.add(road);
  }
}

class Road{
 City start;
 City end;
 float distance;
 
 Road(City start, City end, float distance){
  this.start = start;
  this.end = end;
  this.distance = distance;
 }
}
