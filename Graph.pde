import java.util.Scanner;
import java.awt.geom.Point2D;
import java.util.Collection;
import java.util.Collections;

interface GraphSearch {
  void reset(City start, City goal, HashMap<String, City> cities);
  void update();
  List<Road> shortestPath();
  Collection<City> openSet();
  Collection<City> closedSet();
}


class Graph{
  HashMap<String, City> cities;
  GraphSearch search;
  City start = null;
  City goal = null;
  
  
  Graph(String Citiesfilename, String Roadsfilename, GraphSearch search){
    this.cities = createCities(Citiesfilename);
    createRoads(cities, Roadsfilename);
    this.search = search;
  }
  
  void reset(City start, City goal){
   this.start = start;
   this.goal = goal;
   search.reset(start, goal, cities); 
  }
  
  void update(){
   search.update(); 
  }
  
  void render(){
    float scale = 10f;
    stroke(0,0,0);
    
    for(City city : cities.values()){
      stroke(255,255,255);
      fill(0,0,0);
      square(city.drawx, city.drawy, scale);
    }
    
    // Draw the open and closed sets if available
    Collection<City> open = search.openSet();
    
    if(null != open) {
      noStroke();
      fill(0, 180, 255);
      
      for(City node : open)
        circle(node.drawx, node.drawy, scale * 1.5);
    }
    
    Collection<City> closed = search.closedSet();
    
    if(null != closed) {
      noStroke();
      fill(255, 255, 255);
      
      for(City node : closed)
        circle(node.drawx, node.drawy, scale * 1.5);
    }
    
    // draw shortest path if available
    List<Road> path = search.shortestPath();
    
    if(null != path) {
      strokeWeight(10);
      stroke(200, 200, 0);
      
      for(Road edge : path) {
        float sx = edge.start.drawx;
        float sy = edge.start.drawy;
        float ex = edge.end.drawx;
        float ey = edge.end.drawy; 
        line(sx, sy, ex, ey);
      }
      
      strokeWeight(1);
      
    }
    
    // draw start and goal nodes
    if(null != start) {
      noStroke();
      fill(255,0,0);
      circle(start.drawx, start.drawy , scale * 1.5);
    }
    
    if(null != goal) {
      noStroke();
      fill(0,255,0);
      circle(goal.drawx, goal.drawy , scale * 1.5);
    }   
    
  } // end render
} // end graph

HashMap<String, City> createCities(String filename){
  HashMap<String, City> cities = new HashMap();
  
  BufferedReader reader = createReader(filename);
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ' ');
      String cityName = pieces[0];
      int drawx = int(pieces[1]);
      int drawy = int(pieces[2]);
      City city = new City(cityName, drawx, drawy);
      cities.put(cityName, city);
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return cities;
}

void createRoads(HashMap<String, City> cities, String filename){
  BufferedReader reader = createReader(filename);
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ' ');
      String cityName1 = pieces[0];
      String cityName2 = pieces[1];
      City city1 = cities.get(cityName1);
      City city2 = cities.get(cityName2);
      city1.edgeTo(city2, (float)Point2D.distance(city1.drawx, city1.drawy, city2.drawx, city2.drawy));
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}
  
class LargeGraph{
  boolean foundPath = false;
  HashMap<String, City> cities;
  GraphSearch search;
  City start = null;
  City goal = null;
  
  
  LargeGraph(String filename, GraphSearch search){
    this.cities = createCollabs(filename);
    createCollabEdges(cities, filename);
    this.search = search;
  }
  
  void reset(City start, City goal){
   this.start = start;
   this.goal = goal;
   search.reset(start, goal, cities); 
  }
  
  void update(){
   search.update(); 
  }
  
  void render(){
    List<Road> path = search.shortestPath();
    
    if(null != path && foundPath==false) {
      Collections.reverse(path);
      for(Road edge : path) {
        println(edge.start.name + " ---> " + edge.end.name);
      }
      foundPath = true;
      exit();
    }
  } // end render
  
  float value(int numNodes, int numInPathSoFar){
   // calculate log base 2
   int result = (int)(Math.log(numNodes) / Math.log(2));
   return (numInPathSoFar - result);
 }

} // end graph

HashMap<String, City> createCollabs(String filename){
  HashMap<String, City> cities = new HashMap();
  
  BufferedReader reader = createReader(filename);
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, TAB);
      String cityName = pieces[0];
      String cityName2 = pieces[1];
      City city = new City(cityName, 0, 0);
      City city2 = new City(cityName2, 0, 0);
      cities.putIfAbsent(cityName, city);
      cities.putIfAbsent(cityName2, city2);
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return cities;
} // end createActors

void createCollabEdges(HashMap<String, City> cities, String filename){
  BufferedReader reader = createReader(filename);
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, TAB);
      String cityName1 = pieces[0];
      String cityName2 = pieces[1];
      City city1 = cities.get(cityName1);
      City city2 = cities.get(cityName2);
      city1.edgeTo(city2, 1.0f);
      city2.edgeTo(city1, 1.0f);
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}
